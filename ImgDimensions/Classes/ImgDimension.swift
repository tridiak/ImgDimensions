
import Foundation

public enum ImgSizeType : Int {
	case png = 0
	case gif = 1
	case jpg = 2
	case unknown = 999
}

public struct SImgSize {
	let imgType : ImgSizeType
	var sizes : [(w : UInt32, h: UInt32)]
}

public func GetImageSize(for imgFile: String) -> SImgSize? {
	var isl : ImgSizeList! = nil
	let res = GetImageSizeC(imgFile, &isl)
	
	if res < 0 { return nil }
	guard let imgType = ImgSizeType(rawValue: Int(res)) else  { return nil }
	
	var sis = SImgSize(imgType: imgType, sizes: [])
	sis.sizes.append((w: isl.first.w, h: isl.first.h))
	
	for i in 0..<isl.count {
		let v = isl.others[Int(i)]
		sis.sizes.append((w: v.w, h: v.h))
	}
	
	ImgSizeFree(&isl)
	
	return sis
}
