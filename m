From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables] nft: fix inversion of built-in selectors
Date: Mon, 18 Nov 2013 13:55:48 +0100
Message-ID: <1384779348-18868-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41737 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3KRMz5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:55:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(0ab045f xtables: fix missing ipt_entry for MASQUERADE target) broke
inversion of built-in selectors, such as -s, -d, etc.

We need to refresh the invflags if -p is used or set it for first
time if -p is not used, otherwise inversion is ignored.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-ipv4.c |    4 ++++
 iptables/nft-ipv6.c |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 2ac823f..1afe8b6 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -343,6 +343,10 @@ static void nft_ipv4_post_parse(int command,
 				struct xtables_args *args)
 {
 	cs->fw.ip.flags = args->flags;
+	/* We already set invflags in proto_parse, but we need to refresh it
+	 * to include new parsed options.
+	 */
+	cs->fw.ip.invflags = args->invflags;
 
 	strncpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
 	memcpy(cs->fw.ip.iniface_mask,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index b02d952..f30cec6 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -264,6 +264,10 @@ static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
 		args->flags |= IP6T_F_PROTO;
 
 	cs->fw6.ipv6.flags = args->flags;
+	/* We already set invflags in proto_parse, but we need to refresh it
+	 * to include new parsed options.
+	 */
+	cs->fw6.ipv6.invflags = args->invflags;
 
 	strncpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
 	memcpy(cs->fw6.ipv6.iniface_mask,
-- 
1.7.10.4

