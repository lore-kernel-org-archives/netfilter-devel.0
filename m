From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables 2/3] netfilter: nf_tables: nft_meta: fix socket uid,gid handling
Date: Thu, 19 Sep 2013 22:18:52 +0200
Message-ID: <1379621933-6064-2-git-send-email-pablo@netfilter.org>
References: <1379621933-6064-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3ISUTC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:19:02 -0400
In-Reply-To: <1379621933-6064-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/nft_meta.c: In function =E2=80=98nft_meta_eval=E2=80=99:
net/netfilter/nft_meta.c:82:17: error: incompatible types when assignin=
g to type =E2=80=98u32=E2=80=99 from type =E2=80=98kuid_t=E2=80=99
net/netfilter/nft_meta.c:88:17: error: incompatible types when assignin=
g to type =E2=80=98u32=E2=80=99 from type =E2=80=98kgid_t=E2=80=99

Reported-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 84256bc..8c28220 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
 #include <net/sock.h>
+#include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
=20
 struct nft_meta {
@@ -76,16 +77,35 @@ static void nft_meta_eval(const struct nft_expr *ex=
pr,
 		*(u16 *)dest->data =3D out->type;
 		break;
 	case NFT_META_SKUID:
-		if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL ||
-		    skb->sk->sk_socket->file =3D=3D NULL)
+		if (skb->sk =3D=3D NULL || skb->sk->sk_state =3D=3D TCP_TIME_WAIT)
 			goto err;
-		dest->data[0] =3D skb->sk->sk_socket->file->f_cred->fsuid;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket =3D=3D NULL ||
+		    skb->sk->sk_socket->file =3D=3D NULL) {
+			read_unlock_bh(&skb->sk->sk_callback_lock);
+			goto err;
+		}
+
+		dest->data[0] =3D
+			from_kuid_munged(&init_user_ns,
+				skb->sk->sk_socket->file->f_cred->fsuid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
 	case NFT_META_SKGID:
-		if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL ||
-		    skb->sk->sk_socket->file =3D=3D NULL)
+		if (skb->sk =3D=3D NULL || skb->sk->sk_state =3D=3D TCP_TIME_WAIT)
+			goto err;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket =3D=3D NULL ||
+		    skb->sk->sk_socket->file =3D=3D NULL) {
+			read_unlock_bh(&skb->sk->sk_callback_lock);
 			goto err;
-		dest->data[0] =3D skb->sk->sk_socket->file->f_cred->fsgid;
+		}
+		dest->data[0] =3D
+			from_kgid_munged(&init_user_ns,
+				 skb->sk->sk_socket->file->f_cred->fsgid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
 #ifdef CONFIG_NET_CLS_ROUTE
 	case NFT_META_RTCLASSID: {
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
