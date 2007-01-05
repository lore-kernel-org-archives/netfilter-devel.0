From: Victor Stinner <victor.stinner@inl.fr>
Subject: Patch: add id to libnetfilter_conntrack XML export
Date: Fri, 5 Jan 2007 14:27:36 +0100
Message-ID: <200701051427.37273.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JJlnFZEt4WRUbJO"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_JJlnFZEt4WRUbJO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I heard that connection identifiers may disappear. Is it true? I like unique 
identifier because it's small (only 32 bits) and easy to manipulate. It's 
hard to identify a connection without such identifier.

I attached a patch to add connection identifier to XML export.

Victor Stinner
http://www.inl.fr/

--Boundary-00=_JJlnFZEt4WRUbJO
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack_xml_id.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="libnetfilter_conntrack_xml_id.patch"

Index: src/conntrack/snprintf_xml.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/conntrack/snprintf_xml.c	(r=C3=A9vision 6720)
+++ src/conntrack/snprintf_xml.c	(copie de travail)
@@ -364,6 +364,13 @@
 		buffer_size(ret, &size, &len);
 	}
=20
+	if (test_bit(ATTR_ID, ct->set)) {
+		ret =3D snprintf(buf+size, len, "<id>%u</id>", ct->id);
+		if (ret =3D=3D -1)
+			return -1;
+		buffer_size(ret, &size, &len);
+	}
+
 	if (test_bit(ATTR_MARK, ct->set)) {
 		ret =3D snprintf(buf+size, len, "<mark>%u</mark>", ct->mark);
 		if (ret =3D=3D -1)

--Boundary-00=_JJlnFZEt4WRUbJO--
