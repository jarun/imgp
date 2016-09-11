#
# Fish completion definition for imgd.
#
# Author:
#   Arun Prakash Jana <engineerarun@gmail.com>
#
complete -c imgd -s a -l adapt       --description 'adapt to resolution by orientation'
complete -c imgd -s c -l convert     --description 'convert PNG to JPG format'
complete -c imgd -s d -l dot         --description 'include hidden files (on Linux)'
complete -c imgd -s e -l eraseexif   --description 'erase exif metadata'
complete -c imgd -s f -l force       --description 'force to exact specified resolution'
complete -c imgd -s h -l help        --description 'show help'
complete -c imgd -s i -l includeimgd --description 're-process _IMGD files'
complete -c imgd -s k -l keep        --description 'skip images with matching hres or vres'
complete -c imgd -s n -l enlarge     --description 'enlarge smaller images'
complete -c imgd -s o -l rotate   -r --description 'rotate clockwise by angle (in degrees)'
complete -c imgd -s p -l optimize    --description 'optimize the output images'
complete -c imgd -s q -l quiet       --description 'operate silently'
complete -c imgd -s r -l recurse     --description 'process directories recursively'
complete -c imgd -s s -l scale    -r --description 'scale image by percentage'
complete -c imgd -s w -l overwrite   --description 'overwrite source images'
complete -c imgd -s x -l res      -r --description 'output resolution in HxV representation'
complete -c imgd -s z -l debug       --description 'enable debug logs'
