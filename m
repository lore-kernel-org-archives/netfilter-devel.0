From: "Ariel Rosenblatt" <ariel@blueslice.com>
Subject: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Mon, 7 Feb 2005 14:37:44 -0500
Message-ID: <001001c50d4c$82c102d0$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
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

Hello,

I have run into a problem using the sctp conntrack module.

When an association is terminated without a proper SHUTDOWN it is not
possible to re-establish the same association. The SCTP endpoint will =
send
an INIT message in the original direction to trying to re-establish the
association. However, the INIT_ACK message will be dropped, preventing =
the
association from becoming established.

The following patch solves the problem, the INIT "init_tag" is now saved
properly for an ESTABLISHED sctp association. The "init_tag" (of an INIT
message) wasn't being saved in the proper direction, causing the =
INIT_ACK to
be dropped while verifying the tag ("vtag") at the beginning of
sctp_packet().

I believe this should be the behavior as per RFC 2960, Section 5.2.2.

Cheers,

- Ariel

--- /usr/src/linux-2.6.10/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
2005-02-04 16:22:24.000000000 -0500
+++ ip_conntrack_proto_sctp.c   2005-02-07 13:59:19.049791784 -0500
@@ -401,7 +401,11 @@
                        }
                        DEBUGP("Setting vtag %x for dir %d\n",=20
                                        ih->init_tag, =
CTINFO2DIR(ctinfo));
-                       conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] =
=3D
ih->init_tag;
+                       if (sch->type =3D=3D SCTP_CID_INIT_ACK) {
+
conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] =3D ih->init_tag;
+                       } else {
+                               =
conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY]
=3D ih->init_tag;
+                       }
                    }  =20
=20
                    conntrack->proto.sctp.state =3D newconntrack;
---
