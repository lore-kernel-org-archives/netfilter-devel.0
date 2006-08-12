From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Trivial replace of ip_queue by nfnetlink_queue in
	nfnetlink_queue code
Date: Sat, 12 Aug 2006 16:50:40 +0200
Message-ID: <1155394240.10172.29.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-AnX0lnTIwT842eP9coB5"
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


--=-AnX0lnTIwT842eP9coB5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

This patch replace "ip_queue" by "nfnetlink_queue" in nfnetlink_queue.c.

BR,

Signed-off-by: Eric Leblond <eric@inl.fr>


---

 net/netfilter/nfnetlink_queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

6c270ef9d8727b2b44807b411fb3dd60c87ccf11
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
index 49ef41e..134219c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -584,7 +584,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
                 queue->queue_dropped++;
 		status =3D -ENOSPC;
 		if (net_ratelimit())
-		          printk(KERN_WARNING "ip_queue: full at %d entries, "
+		          printk(KERN_WARNING "nfnetlink_queue: full at %d entries, "
 				 "dropping packets(s). Dropped: %d\n",=20
 				 queue->queue_total, queue->queue_dropped);
 		goto err_out_free_nskb;
@@ -635,7 +635,7 @@ nfqnl_mangle(void *data, int data_len, s
 			                         diff,
 			                         GFP_ATOMIC);
 			if (newskb =3D=3D NULL) {
-				printk(KERN_WARNING "ip_queue: OOM "
+				printk(KERN_WARNING "nfnetlink_queue: OOM "
 				      "in mangle, dropping packet\n");
 				return -ENOMEM;
 			}
--=20
1.1.3

--=20
Eric Leblond <eric@inl.fr>
INL

--=-AnX0lnTIwT842eP9coB5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBE3erAnxA7CdMWjzIRAhwUAJ9zN3YIAgCg1YaceI9nWtAobs/aWQCcDgIO
cxtlWECgyzi5F0q7lTO8G8k=
=AlxK
-----END PGP SIGNATURE-----

--=-AnX0lnTIwT842eP9coB5--
