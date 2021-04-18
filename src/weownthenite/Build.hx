package weownthenite;

#if macro
import sys.FileSystem;
using StringTools;
using haxe.io.Path;
#end

macro function getVideoFiles( path : String ) : ExprOf<Array<String>> {
	var names = FileSystem.readDirectory( path ).filter( e  -> {
		return
			!e.startsWith( '.' )
			&& !e.startsWith( '_' )
			&& e.extension() ==  "mp4"
			&& !FileSystem.isDirectory( '$path/$e' );
	}).map( f -> return f.withoutExtension() );
	return macro $v{names};
}
