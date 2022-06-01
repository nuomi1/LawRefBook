import Foundation
import SwiftUI

struct SharingViewController: UIViewControllerRepresentable {
    
    @Binding
    var isPresenting: Bool
    
    var completion: () -> Void
    
    var content: () -> UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresenting {
            uiViewController.present(content(), animated: true, completion: completion)
        }
    }
}

struct ShareByPhotoView: View {
    
    var law: TLaw
    var text: String
    
    var cleanText: String {
        return String(format: "%@\n\n%@", law.name, text)
    }
    
    @Environment(\.dismiss)
    var dismiss
    
    @State
    private var shareing = false
    
    var shareView: some View {
        VStack {
            Text(law.name)
                .font(.title)
                .padding([.bottom, .top], 8)
                .multilineTextAlignment(.center)
            Text(text)
                .padding([.bottom], 8)
                .padding([.trailing, .leading], 4)
                .multilineTextAlignment(.leading)
            HStack {
                Spacer()
                Image(uiImage: generateQRCode(from: "https://apps.apple.com/app/apple-store/id1612953870"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }
        }
        .padding()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                shareView
                    .snapView()
                Button {
                    shareing.toggle()
                } label: {
                    Text("分享")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding([.leading, .trailing], 8)
            }
            .padding()
        }
        .background(SharingViewController(isPresenting: $shareing, completion: {
            shareing = false
        }, content: {
            let av = UIActivityViewController(activityItems: [shareView.snapView().asImage()], applicationActivities: nil)
            av.completionWithItemsHandler = { _, _, _, _ in
//                dismiss()
            }
            return av
        }))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CloseSheetItem {
                    dismiss()
                }
            }
        }
    }
    
}


struct ShareByPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let cate = TCategory(id: 1, name: "123", folder: "123", isSubFolder: false, order: 1, group: nil, laws: [])
        let law = TLaw(id: UUID(), name: "民法典合同编很长很差很功能很差很难过", category: cate, expired: false, level: "", filename: nil, publish: nil, order: 1, subtitle: nil, is_valid: true)
        ShareByPhotoView(law: law, text: "第四百一十条 一二打卡减肥看来大家快点放假啊快点放假啊看了计分卡家乐福看见啊离开家");
    }
}