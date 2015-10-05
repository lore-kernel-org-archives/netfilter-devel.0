From: Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH nf-next] netfilter: bridge: fix 2 compiler warnings
Date: Mon,  5 Oct 2015 18:13:08 +0200
Message-ID: <1444061588-1692-1-git-send-email-razor@blackwall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, fw@strlen.de, bernhard.thaler@wvnet.at,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34616 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbJEQOs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 12:14:48 -0400
Received: by wicfx3 with SMTP id fx3so127843668wic.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2015 09:14:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

While looking at the kasan warning, I noticed there're 2 more warnings
when CONFIG_NF_DEFRAG_IPV6 and CONFIG_NF_DEFRAG_IPV4 are not defined.

1.
net/bridge//br_netfilter_hooks.c: In function =E2=80=98br_nf_dev_queue_=
xmit=E2=80=99:
net/bridge//br_netfilter_hooks.c:730:25: warning: variable =E2=80=98nf_=
bridge=E2=80=99
set but not used [-Wunused-but-set-variable]
- Introduced by
commit efb6de9b4ba0 ("netfilter: bridge: forward IPv6 fragmented packet=
s")

2.
net/bridge//br_netfilter_hooks.c: In function =E2=80=98br_nf_dev_queue_=
xmit=E2=80=99:
net/bridge//br_netfilter_hooks.c:797:2: warning: label =E2=80=98drop=E2=
=80=99 defined
but not used [-Wunused-label]
- Introduced by
commit dd302b59bde0 ("netfilter: bridge: don't leak skb in error paths"=
)

Simply pull the code inside the respective ifdefs.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Compile-tested only. Patch applies to DaveM's net-next and also to
git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

 net/bridge/br_netfilter_hooks.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
index 13f03671c88d..adf50432b189 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -727,7 +727,6 @@ static unsigned int nf_bridge_mtu_reduction(const s=
truct sk_buff *skb)
=20
 static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, stru=
ct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge;
 	unsigned int mtu_reserved;
=20
 	mtu_reserved =3D nf_bridge_mtu_reduction(skb);
@@ -737,18 +736,20 @@ static int br_nf_dev_queue_xmit(struct net *net, =
struct sock *sk, struct sk_buff
 		return br_dev_queue_push_xmit(net, sk, skb);
 	}
=20
-	nf_bridge =3D nf_bridge_info_get(skb);
-
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
 	if (skb->protocol =3D=3D htons(ETH_P_IP)) {
+		struct nf_bridge_info *nf_bridge;
 		struct brnf_frag_data *data;
=20
-		if (br_validate_ipv4(net, skb))
-			goto drop;
+		if (br_validate_ipv4(net, skb)) {
+			kfree_skb(skb);
+			return 0;
+		}
=20
+		nf_bridge =3D nf_bridge_info_get(skb);
 		IPCB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
 		nf_bridge_update_protocol(skb);
@@ -769,11 +770,15 @@ static int br_nf_dev_queue_xmit(struct net *net, =
struct sock *sk, struct sk_buff
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
 		const struct nf_ipv6_ops *v6ops =3D nf_get_ipv6_ops();
+		struct nf_bridge_info *nf_bridge;
 		struct brnf_frag_data *data;
=20
-		if (br_validate_ipv6(net, skb))
-			goto drop;
+		if (br_validate_ipv6(net, skb)) {
+			kfree_skb(skb);
+			return 0;
+		}
=20
+		nf_bridge =3D nf_bridge_info_get(skb);
 		IP6CB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
 		nf_bridge_update_protocol(skb);
@@ -794,9 +799,6 @@ static int br_nf_dev_queue_xmit(struct net *net, st=
ruct sock *sk, struct sk_buff
 #endif
 	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(net, sk, skb);
- drop:
-	kfree_skb(skb);
-	return 0;
 }
=20
 /* PF_BRIDGE/POST_ROUTING ********************************************=
/
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
