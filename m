From: Eric Leblond <eric@inl.fr>
Subject: PATCH] nfnetlink_queue Fix typo on debug message
Date: Thu, 10 Aug 2006 15:55:32 +0200
Message-ID: <1155218132.10883.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-TS1G7RmIxl0UhtSDuCkp"
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


--=-TS1G7RmIxl0UhtSDuCkp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch fixes a trivial typo in nfnetlink_queue.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nfnetlink_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
index 86a4ac3..d9a2ad8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -584,7 +584,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
                 queue->queue_dropped++;
 		status =3D -ENOSPC;
 		if (net_ratelimit())
-		          printk(KERN_WARNING "ip_queue: full at %d entries, "
+		          printk(KERN_WARNING "nf_queue: full at %d entries, "
 				 "dropping packets(s). Dropped: %d\n",=20
 				 queue->queue_total, queue->queue_dropped);
 		goto err_out_free_nskb;
--=20
1.4.1



--=-TS1G7RmIxl0UhtSDuCkp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBE2zrUnxA7CdMWjzIRArPcAJ4y1yfAnS23rAQ4PYaXocvw6gH2OACffS/n
s56n2K2WE8FZ55WM60ytdpc=
=8nYR
-----END PGP SIGNATURE-----

--=-TS1G7RmIxl0UhtSDuCkp--
