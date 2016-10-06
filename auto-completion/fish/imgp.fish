#
# Fish completion definition for imgp.
#
# Author:
#   Arun Prakash Jana <engineerarun@gmail.com>
#
complete -c imgp -s a -l adapt       --description 'adapt to resolution by orientation'
complete -c imgp -s c -l convert     --description 'convert PNG to JPG format'
complete -c imgp -s d -l dot         --description 'include hidden files (on Linux)'
complete -c imgp -s e -l eraseexif   --description 'erase exif metadata'
complete -c imgp -s f -l force       --description 'force to exact specified resolution'
complete -c imgp -s h -l help        --description 'show help'
complete -c imgp -s i -l includeimgp --description 're-process _IMGP files'
complete -c imgp -s k -l keep        --description 'skip images with matching hres or vres'
complete -c imgp -s n -l enlarge     --description 'enlarge smaller images'
complete -c imgp -s o -l rotate   -r --description 'rotate clockwise by angle (in degrees)'
complete -c imgp -s p -l optimize    --description 'optimize the output images'
complete -c imgp -s q -l quiet       --description 'operate silently'
complete -c imgp -s r -l recurse     --description 'process directories recursively'
complete -c imgp -s w -l overwrite   --description 'overwrite source images'
complete -c imgp -s x -l res      -r --description 'output resolution in HxV or %'
complete -c imgp -s z -l debug       --description 'enable debug logs'
