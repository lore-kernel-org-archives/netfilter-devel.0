From: netfilter@interlinx.bc.ca
Subject: ip_conntrack-timeouts conflicts with tcp-window-tracking
Date: Fri, 25 Oct 2002 16:34:34 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021025203433.GJ23228@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ONvqYzh+7ST5RsLk"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ONvqYzh+7ST5RsLk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Which should I prefer, or should I merge them by taking the bulk of
the tcp-window-tracking patch and replace the references to timeout
constants with the sysctl controlled timeout values that
ip_conntrack-timeouts provides?

So for an example, tcp-window-tracking has this patch:

--- linux-2.4.19-base/net/ipv4/netfilter/ip_conntrack_proto_udp.c       Fri=
 Oct 18 11:38:10 2002
+++ linux-2.4.19-tcp-window/net/ipv4/netfilter/ip_conntrack_proto_udp.c Fri=
 Oct 18 11:56:35 2002
@@ -6,6 +6,9 @@
 #include <linux/udp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_udp.h>
+
+unsigned long ip_ct_udp_timeout =3D 30*HZ;
+unsigned long ip_ct_udp_timeout_stream =3D 180*HZ;
=20
 static int udp_pkt_to_tuple(const void *datah, size_t datalen,
                struct ip_conntrack_tuple *tuple)
@@ -52,11 +52,11 @@
    /* If we've seen traffic both ways, this is some kind of UDP
       stream.  Extend timeout. */
    if (conntrack->status & IPS_SEEN_REPLY) {
-               ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
+               ip_ct_refresh(conntrack, ip_ct_udp_timeout_stream);
        /* Also, more likely to be important, and not a probe */
        set_bit(IPS_ASSURED_BIT, &conntrack->status);
    } else
-               ip_ct_refresh(conntrack, UDP_TIMEOUT);
+               ip_ct_refresh(conntrack, ip_ct_udp_timeout);
=20
    return NF_ACCEPT;
 }

But, ip_conntrack-timeouts has this conflicting patch:

--- linux-2.4.20-pre7.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c  200=
2-09-14 20:08:16.000000000 +0200
+++ linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_proto_udp.c       200=
2-09-19 21:57:47.000000000 +0200
@@ -5,9 +5,7 @@
 #include <linux/in.h>
 #include <linux/udp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
-
-#define UDP_TIMEOUT (30*HZ)
-#define UDP_STREAM_TIMEOUT (180*HZ)
+#include <linux/netfilter_ipv4/ip_conntrack_udp.h>
=20
 static int udp_pkt_to_tuple(const void *datah, size_t datalen,
                struct ip_conntrack_tuple *tuple)
@@ -52,11 +50,13 @@
    /* If we've seen traffic both ways, this is some kind of UDP
       stream.  Extend timeout. */
    if (conntrack->status & IPS_SEEN_REPLY) {
-               ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
+               ip_ct_refresh(conntrack,=20
+                       sysctl_ip_conntrack_udp_timeouts[UDP_STREAM_TIMEOUT=
]);
        /* Also, more likely to be important, and not a probe */
        set_bit(IPS_ASSURED_BIT, &conntrack->status);
    } else
-               ip_ct_refresh(conntrack, UDP_TIMEOUT);
+               ip_ct_refresh(conntrack,=20
+                       sysctl_ip_conntrack_udp_timeouts[UDP_TIMEOUT]);
=20
    return NF_ACCEPT;
 }


I sure like the idea of the tcp window tracking patch and would like it,
but I also like being able to control timeouts via sysctl rather than
having to use defined constants.

Would there be any danger in merging these two features manually into my
kernel source?

b.

--=20
Brian J. Murrell

--ONvqYzh+7ST5RsLk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9uarZl3EQlGLyuXARAp04AKDzwRFbLvIZBJwxHQ476I5hgle6uwCgoV+R
Zk2jqXA6i7XKp7UN/cntkOQ=
=wKdm
-----END PGP SIGNATURE-----

--ONvqYzh+7ST5RsLk--
--ONvqYzh+7ST5RsLk--
