
function middlePointBetween(point1, point2) {
    var newX = (point2.x - point1.x)/2;
    var newY = (point2.y - point1.y)/2;

    var newPoint = GreatPoint.pointWithXAndY(newX, newY);
    return newPoint;
}

function middlePointBetweenWithBlocks(point1, point2) {
    var newX = (point2.x - point1.x)/2;
    var newY = (point2.y - point1.y)/2;
    
    var newPoint = createNewPointWithXY(newX, newY);
    return newPoint;
}