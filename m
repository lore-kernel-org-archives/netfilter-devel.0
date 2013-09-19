From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Problem compiling nftables kernel
Date: Thu, 19 Sep 2013 12:07:07 +0200
Message-ID: <20130919100707.GA4193@localhost>
References: <CAJO99T=QRpNUmmdfXVj6xfNp_gDqRszfAzjSkygGsoyCKhJN=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51418 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3ISKHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:07:24 -0400
Content-Disposition: inline
In-Reply-To: <CAJO99T=QRpNUmmdfXVj6xfNp_gDqRszfAzjSkygGsoyCKhJN=Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 19, 2013 at 11:28:31AM +0200, Bjørnar Ness wrote:
> git: 6b92ef23eb12021c5ffe3ff03f60f6e0359c02c2
> 
> x86_64
> 
> net/netfilter/nft_meta.c: In function ‘nft_meta_eval’:
> net/netfilter/nft_meta.c:82:17: error: incompatible types when
> assigning to type ‘u32’ from type ‘kuid_t’
> net/netfilter/nft_meta.c:88:17: error: incompatible types when
> assigning to type ‘u32’ from type ‘kgid_t’

Please, give a try to the attached patch.

Thanks.

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="meta.patch"

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 84256bc..4c6998d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
 #include <net/sock.h>
+#include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 
 struct nft_meta {
@@ -76,16 +77,35 @@ static void nft_meta_eval(const struct nft_expr *expr,
 		*(u16 *)dest->data = out->type;
 		break;
 	case NFT_META_SKUID:
-		if (skb->sk == NULL || skb->sk->sk_socket == NULL ||
-		    skb->sk->sk_socket->file == NULL)
+		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
 			goto err;
-		dest->data[0] = skb->sk->sk_socket->file->f_cred->fsuid;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket == NULL ||
+		    skb->sk->sk_socket->file == NULL) {
+			read_unlock_bh(&skb->sk->sk_callback_lock);
+			goto err;
+		}
+
+		dest->data[0] =
+			from_kuid_munged(&init_user_ns,
+				skb->sk->sk_socket->file->f_cred->fsuid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
 	case NFT_META_SKGID:
-		if (skb->sk == NULL || skb->sk->sk_socket == NULL ||
-		    skb->sk->sk_socket->file == NULL)
+		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
+			goto err;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket == NULL ||
+		    skb->sk->sk_socket->file == NULL) {
+			read_unlock_bh(&skb->sk->sk_callback_lock);
 			goto err;
-		dest->data[0] = skb->sk->sk_socket->file->f_cred->fsgid;
+		}
+		dest->data[0] =
+			from_kuid_munged(&init_user_ns,
+				 skb->sk->sk_socket->file->f_cred->fsgid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
 #ifdef CONFIG_NET_CLS_ROUTE
 	case NFT_META_RTCLASSID: {

--YZ5djTAD1cGYuMQK--
