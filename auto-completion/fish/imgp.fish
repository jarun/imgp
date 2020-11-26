#
# Fish completion definition for imgp.
#
# Author:
#   Arun Prakash Jana <engineerarun@gmail.com>
#
complete -c imgp -s a  -l adapt       --description 'adapt to resolution by orientation'
complete -c imgp -s c  -l convert     --description 'convert PNG to JPG format'
complete -c imgp -s e  -l eraseexif   --description 'erase exif metadata'
complete -c imgp -s f  -l force       --description 'force to exact specified resolution'
complete -c imgp -s H  -l hidden      --description 'include hidden (dot) files'
complete -c imgp -s i  -l includeimgp --description 're-process _IMGP files'
complete -c imgp -s k  -l keep        --description 'skip images with matching hres or vres'
complete -c imgp -s m  -l mute        --description 'operate silently'
complete -c imgp -s M  -l minres   -r --description 'minimum resolution in HxV or %'
complete -c imgp -s n  -l enlarge     --description 'enlarge smaller images'
complete -c imgp -s N  -l nearest     --description 'use nearest neighbour interpolation for PNG'
complete -c imgp -s o  -l rotate   -r --description 'rotate clockwise by angle (in degrees)'
complete -c imgp -s O  -l optimize    --description 'optimize the output images'
complete -c imgp -l P  -l progressive --description 'save JPEG as progressive'
complete -c imgp -s q  -l quality  -r --description 'specify quality factor (1-95)'
complete -c imgp -s r  -l recurse     --description 'process directories recursively'
complete -c imgp -s s  -l size     -r --description 'min byte size to process an image'
complete -c imgp -s w  -l overwrite   --description 'overwrite source images'
complete -c imgp -s x  -l res      -r --description 'output resolution in HxV or %'
complete -c imgp -s d  -l debug       --description 'enable debug logs'
complete -c imgp -s h  -l help        --description 'show help'
