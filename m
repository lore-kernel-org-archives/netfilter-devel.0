From: Victor Stinner <victor.stinner@inl.fr>
Subject: Fix XML output (with new libnetfilter_conntrack API)
Date: Thu, 28 Dec 2006 20:00:02 +0100
Message-ID: <200612282000.02813.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yQBlFSOIeQeb3oK"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_yQBlFSOIeQeb3oK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I found a little mistake in new libnetfilter_conntrack API, in snprintf() code 
with XML output. I attached a patch to fix it.

Victor Stinner
http://www.inl.fr/

--Boundary-00=_yQBlFSOIeQeb3oK
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack_snprintf_xml.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="libnetfilter_conntrack_snprintf_xml.patch"

Index: src/conntrack/snprintf_xml.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/conntrack/snprintf_xml.c	(r=C3=A9vision 6716)
+++ src/conntrack/snprintf_xml.c	(copie de travail)
@@ -321,10 +321,10 @@
 			ret =3D snprintf(buf, len, "<flow type=3D\"new\">");
 			break;
 		case NFCT_T_UPDATE:
=2D			ret =3D snprintf(buf, len, "<flow type=3D\"update\"");
+			ret =3D snprintf(buf, len, "<flow type=3D\"update\">");
 			break;
 		case NFCT_T_DESTROY:
=2D			ret =3D snprintf(buf, len, "<flow type=3D\"destroy\"");
+			ret =3D snprintf(buf, len, "<flow type=3D\"destroy\">");
 			break;
 		default:
 			ret =3D snprintf(buf, len, "<flow>");

--Boundary-00=_yQBlFSOIeQeb3oK--
