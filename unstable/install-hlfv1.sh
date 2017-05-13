(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� c�Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�$1!�/�c��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�X]ɿ�&���W&����'*���7������r����J�e�B�߽�W쭳�r�h����/���u���L���O-*���k��O'^���r�I�8
�"�;y?��{4%i�K��I�y�;��q��Y��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ܫ�s�!������?N���?^|��RC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ί�������7�/�ۋ�K�O�?w�a�aT��W
>J�wWǷ׉=x�+�%p��'�J�����uC�d�P���_������� �9ʚ���d���̐�Ys)n[D� m.W�����4̸PѲ�5K05�!�-sp�x@"�)m�2{8޺�X�8T8�T��u�IY�!kH��:s�� ���"�s����� �D��P59�|�[�G���;�#F�`��"(�r�,D1�`�E��W�e�%���=�(�i*;� t�|������i,"om졸�f`p�s�,�\Í���-���
�@��[���i\1��㡹7��R1���)n�M�'
�No

�8�WňP�<�9���n$�)a7�a/�-��bc���9}���)�h'�rVr�P����]i�Y&n��Vw�t3עf��)�8~O�E�5�(�dz�1h���@���kp+O<7��p `��Q�:��xY���"cR��M����� ��z`m:�������}�\)L�B�<@B��^�x�:tr �	>��-�F\Ę�2�`���>;��ߵs9䖓�%���D�b�ՇL�@�"=�cш�̢O�Q��>,>0����{e��_���4|����Q���R�A�T��x��ѧ���$^�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EY��`����2E�w�����0EWrH<�0��'�5�%��;�b��V.�S]S�Q���lM�HM\L���C�n�߻e�.�i���ռ��ž@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^T��!��
 y;?�d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D�bH}0�m�`B2���q���D���ϛX��X��P���o�m������}?��Z2��h�Y�!���:��x��_�������$U�����Ϝ�/����*�/��_�����������x9�(�W�_~I���S�������~}��>E8�b�P6[\� �H���0M���H@�.���Ca��(����U�?ʐ�+�ߏ������J��?|�'��&�<i�'�ˬ�YB�+<�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a��^�������*��|��?<����������j����{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����n�]���� ���&s�P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\,Х7(w�j��1<tO��1G�������t���stNnq���*�*�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�d҄�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?�����'���t��e�C���?�����������s�7��~w
���-T�_.��+4�".��@���KA���W��������R�m-J�*��\��c�^8���`h@��C0���xκ���3,���0��(͒$eWQ~�ʐ���M��W.��S��+��JU,o86'��t�lc�=GZu�-���=yA
/����w�<��i%���䎢�$���x5�`O@��嘱U��v���u{b"�4x6���MF��sJɩ�nV������z~��)�/��Q����������Y�߱�CU������}}�R�\�8AW��W�
o_��.�?��T%�2���8����Q������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���F�u� p�`���m�a}��(*e����9���>��t����0Qx1�v�z���`�]��c��F����_��Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l���y7>r��t��AU�_)��?�$���������'��՗FU(e���%ȧ���U��P
^��j�<�{��΁X�qе
�%,�!?��<�}t�gI �����7����*-û���֍��{�.���@7�Gy���D���=�Z�a��=
'���N1��+݅��ΈA??$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�3b��Cb����k�Cba΅�x|�s�[SW�m��Dk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\�����|t{@�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4������������q���K�oa�Sxe��M��������-Q��_�����$P���^
�v���c��_��n�$��T�wxv�#�����2?yf(?��G�tw��@�O΁@�q[z-PS �]��'n����I>�AB���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&���A@OB�=��܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/�����Gh���+���O>��������X����?e��=���������G��_��W����������\l�cV��s9�\��[w�?F!t�Y
*������?�����z��S��[)���	��i;�h��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q����V(C���?��B���O)���PZ�d��a�2�f�����9��6ض��"o䑶hQ����hN�m�`]	otw�K��#`����;VaDI�1�ַ����0�k�d=�(G��b(���:�b��W��/v�~Z��(�3�z->�?_�h�ڟ�!
�Z�e`�Y���������O�S�ϾB��k#�K�6����Z��?]�^X,��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}�I�vU� ���n�]E��k��]�������8]g���/!����u*+&nd/���lR�rk=�G�(�u��(�>�VӅ_{��O�}��8�h��/��dΫ]9��������ڕw�m��D��1��/�������v��k{��ӛ��µo�nnm�ۙ��]�+���Es���.�7Quй��}CT� �b���>�y���ڗ��h4�·�l_k*ɝ���@�w�:��4̮o�ʵ�(��˝���{��{�@���ւ�?�A�%wۋ70:��bl��X|W{���e�-o�� ��O[/�������
��8�?���z����n��A��~+�~�����=�����E�����w�j���2����'k8�{=��ԅ��z�q������Hj�Z�a�MX�@��)��x���&�f����pF�=��é��pls�b໺x�7���]A�G"?0DCV�����-��mUqd|[��q��kF�ue���YNw_a�����)�n��ْ��.��'{b1o����ƺN�q�\.����P�\p3\�=^��{�P��[���ۺ�Mɵ���m����&�_���M�F����'%�A�~Q>(��1���v[�v���s8\��䞮�?/}������=ϣ�����^ҋM�3���&�+7�fPB@�!bWH?K$d,�³���`�^�5��db�K�t$�uk[֎	������������x��}3-�Y�.-`�@��l^���<<��M�9��]L�aG[�UY���o�Ϳ�k�98Q7N���9䖙I��*E7 �G�o0�`5S��#KFl�M�M]�{�*i ����Ǚ���9�%	J��h2��n�B2MѺ�|b\�z��Wَ�~�x7�s�M8ZFL�5���qUfMi�<"�*��@�3�2l����Y#~��y�-��!c�Q��U�.��us�5FSd9�"l4]�!�[4]h�p�N�f��Ԇӣ��oN��8u�#8���i��N�-����e;�~Q�؁�ʝVeQo߃�0�}����Z�1u�c]�t����$�J�8R���[���u�p8��l���)U6^�5�}3��(�tn�~������G�JTx�Sk�Q�!��2ifqt��h>_[��E�/�0�g�����!��a���|�X�.�"��5J��A����5�P�kN����~FhNf�r�_�Ԟk{�z&_G��f���pc�Q��;�<��s�����F�?I���`�cNJ��XȐ���kv���z����{�3��7��;^k���{�}C�����wu�^�]�_��:|����Yޮ��,�:sNN�+zU5�g�f��h�8��\^!�=��h����v�ݪc��?n���g��j��g�y�x%���֞��c?��y���F�n���=� �l{Q��G�ض��� ��l��U�>*`�
�����PN���!8ix����ۯ�q��p=vk5�������v��?z��P`�ҍ'(�gNp�8��	�~' �qq��;7~t\e>s��9�s3׿� Rc�36�O�7���7�9#Y����z7��yx/*r	:���z�Gg��1��<'̞��i~"�{X���;��l�Fa��ް���j3������c��[�6p��gH���"��vz�p�6�, �NY���/���Ur��a���y������>'���h�d����os��[�&�<��tw@?�Q�R��p����O�Y:8�.�cJt��'d�>��5�B(���J���*
.2!�ʞZ=��QB�Qʋr˩jK�	I�����	m���2Ų��z)5��I��^
Qx�K�����O�LX�	k3aWa�BO���!a�}6<�����֦���蚝�R3��=`����nUCLpl-��)و�[�]�d ����D`����2���ׯl�L��ITh�[��@kpGBI1&�w8��H�0�ᐕd�&���)�i�A��#ky�<��{�gd��
��D6ar��[E<��*�uвBP��Z�����/�d����ka(FIs�N��{�]��n&�uz;/rA�f�]���w�w_Y�Ǥ,K6`�Q�-wf3��Y.�};�J�`8�N3����=-���b��"�~%�c�TKlR�B�]l��P��2���6u8e���kE����B�
(��}Lϴ�Ԝ����]�,QՃ�|�>��IB��1�U`�@N�0�ՉD�'o�"���2V�9�NTA��-$�R�H͏�L9�+T�n_,!���B��{�,�E��_�,�������D�X�g(ߪpy�$�~	J hb�N
����m0/�W�<��C�a\�孝\;1���l�����0�h�	��%,&kRl���(� �0)W:S�dNY���.U&�	{�>��m�j�O%U��� K���Z�`	!��&�tчn0�fCRw|D��5U�MHy��P��H6)��2H�=�b���,N�g�}6�g[�g�8�?͉�k
j�ͫ���ڕ������X�b�t�������G�ȡ��>�g:3�g����<[9TUw��l����iC7B׀��^WS�D�g�7?�d������8��J���ɍ;�M�(��浶Z3�jh��TU����u��@�u�8�ɒl�8��fk2�!��^�?�r���m:��9�Y�
���',����A̳R�b���^��zS�Y�fɌOL�L��r��΃Ӹ��}1����ːX1#������8QV��g�� �6#���'���W�V�<r�(���:��:��������`嗂��G&���I(�L���D �
w�<[ٹ��c_x�RGB�-u4gG����`4(Y�y�S�.8Xڳ���� G]pp�*`z�͚2�pO���f"�'�MMpgHmJ�~���6�`V
tQ&���D�?$Zq$B"���$�A�[D�l1�<�ם�d�Nj\�W/����ك�A����h1A��Cx$(��c|�4&�CҸ9d�����p,Q�4L�u{��p������Z�d����4�����t�Jܯ�-e�{���\�z]���a��N��S��l��I!jAu��,`�0Iz�����q��{��kN�8l㰍� ?ֵ�%�ݦ;��L9��h�L��L+�@,���]�֩�C���>���r�a��ߺr������=,�e��H�'��� ��
���R��D�\�L��y�6�@*opdw��A��RT��<X=(��E&1pԠȤU`�n֔e��������l0�Q�JS�N\�Ai�$S8"�S��\�	�(��|��0��J��!�r{:�,w�������RJB�����!{c!����XQ�n�a��v9L���R�oG=;�A)ʓC��D��FP^�˗v���e��>*߯z�TO�r�PF\p�I T?�Ì>�Е-����q��51�%�p��M��r���t;�$��K�����+{X�q����f��~ܳ���2�����+��V
ɭf۸n5�v!��FYM���L[�p�jF��������M�RQyM�5��n ���y-��`}\(.	�~b��5p*��^�qWꕻ��F���q:]a�����z��߾��z�O#���z���~ח^���o����5�j����i6-��~�u��D�{���yl��eI���x��?��A������/@7�~ ~�߼�/>���ȟ�?	}/����āܺv���k�2���ۼ6�NT�@��7⟿�{拍�I7�����˿��o|�I�u
�FA��?MQ;_pBo�R;_���6�Ӧv�4�&`S;�������v@�H��N��iS;m�������C�-/#��!H���@��,a�f��	��k�m�����@=�x�1C'}�~���צ�	/B6��v�l���)���j�l㰍�=��#y��� 3X��kS�l�yZ��;�jϙ�����93�q��q��a����\��9�;w��ڪ��w�<z�d���Z�������d';�o�V �r  