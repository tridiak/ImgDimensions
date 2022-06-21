import XCTest
import ImgDimensions

class Tests: XCTestCase {
    
	private var imgPath : String! = nil
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let b = Bundle(for: type(of: self))
		if let path = b.path(forResource: "garf", ofType: "gif") {
			imgPath = path
		}
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetImagSizeC() {
        // Direct C interface check
        
		XCTAssertNotNil(imgPath)
		
		var isl : ImgSizeList! = ImgSizeList()
		let res = GetImageSizeC(imgPath, &isl)
		
		XCTAssert(res >= 0)
		XCTAssertEqual(res, Int32(imgTypeGIF.rawValue))
		XCTAssertEqual(isl.first.w, 600)
		XCTAssertEqual(isl.first.h, 171)
		
		XCTAssertEqual(GetImageSizeC("/Gobblygook.png", &isl), -1)
    }
	
	func testSwiftWrapper() {
		let imgSizeStruct : SImgSize? = GetImageSize(for: imgPath)
		
		XCTAssertNotNil(imgSizeStruct)
		if let sis = imgSizeStruct {
			XCTAssertEqual(sis.imgType, ImgSizeType.gif)
			XCTAssert(sis.sizes.count > 0)
			if sis.sizes.count > 0 {
				XCTAssertEqual(sis.sizes[0].w, 600)
				XCTAssertEqual(sis.sizes[0].h, 171)
			}
		}
		
		XCTAssertNil(GetImageSize(for: "/Gobblygook.png"))
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
