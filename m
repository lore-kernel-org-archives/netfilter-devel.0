Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826782;
	b=Wfu6DRmfG/WRTQ9Eb6GCtPUwMPwRWPNwALMgtCAqBEvFtVloYR5YAx/iN+sRUVSrMTtn
	 4+HHoFs8SN1GlY0xmY6UwHuqxMETXhlaO1NENEIAhyyHTwO+RpC43ilA7iwwCw91wRDAf
	 GlyIRC09OoLPjUObxW8R0y/OGDOczD+7XploIgr3HcvnQ9Ooe8xc/A61jRGekrS2gKZb8
	 tWPYABA6Kurt1QsFYYtnx/WS6hOJtB4XdUtz6L8WPrGR1fj5xsA3dT0M7+lHdg/Jf/qmH
	 wpoNAECPEDndHsR6hXhJwVfsWoa1Q4hmPKa0utrqOHo1Ck/ZZGGBIeoC7Cr8WHq2VlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826782;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=we2BSTl/wz7wbvkTPkyGibVFrxPHLtiOcNNkkIcz4FY=;
	b=OYIK3pJtYzAOt0f2W7wpWS6e33xLOoexjFXqImDaf9VUkJUbU+lN9hkZPph6FQhbc/Uo
	 F14giqxSMo1JDKCnEGCPn0mRqQPHwHFdVlssMvk4DBI17rGIup2IpGPueMS/vB+DueGY+
	 3B4ojjI3ECA/5uD8lJG/XVxuG1Qwj8GuYrXl6J3mCyeLzYKZ1ip9qBNkM9canxnyUvgDh
	 tXIJB84g7qnJfPPkC7YmJmQ9OYnYC0T2CmOyRjZBAh5Q/LRPgTK2Is9AeIZ6DAqqkw9Mz
	 D50I6K/Yp/AO89uxHPZgBQFiKvZq8f5ARi3uXwAr5DjP5uUsswrrsdpfT9Abgpvs78w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MaYANeav;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4C5606A323
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F4C5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MaYANeav
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826778;
	bh=we2BSTl/wz7wbvkTPkyGibVFrxPHLtiOcNNkkIcz4FY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MaYANeav9PBvdPMxjwc1oQBaIUxRzf089IGSB+LfXegkfo/wtEqI9GReEhVyVzLJN
	 xwDJxGE67bJsfS9Nl+zCavgQSDpiVuXByn+xkvrh1vWQZArsBpnm8nb8z7/hTQ9zYD
	 3HoCX/vekQRCc9XLZ5CAcrKoq1uSd3+bYuij0yve3cBh5C48sp+fBunO12a6bXYMJd
	 /Ix4jauqDl/4xNAtXTSnMYPRoI8YDPc10PvczjJMhWgfRl4t0QxucB0z9E0ofdktoU
	 +ay0Ux8uc7OFPiMT1g6o3nvD6a2SY5h2gUrmSH6M3H136hxbyJxePP72okTd/xFB8a
	 CyMk6cGsRa5xg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 747B860091
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 5/7] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Mon, 16 Nov 2026 11:59:29 +0100
Message-ID: <20261116105931.2866911-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116105931.2866911-1-pablo@netfilter.org>
References: <20261116105931.2866911-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding expectations to unconfirmed conntracks from any hook is
problematic because of reallocations of the ct extension area can happen
while expectations are placed in the ct extension expectation list.

Note that NFQA_EXP was added with the purpose of supporting userspace
conntrack helpers, which create expectations in confirmation hook.

This patch restricts expectation creation to userspace ct helpers to the
conntrack confirmation hook (ie. NF_HOOK_OP_CONNTRACK), where the
expectation creation for userspace helpers is allowed.

On packet reinjection, hook updates could result in a stale hook_index
that point to different hooks, just ignore NFAQ_EXP if this packet lands
in the wrong hook after (un)registration hook updates.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Reported-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v9: update commit description

 net/netfilter/nfnetlink_queue.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c9773c4fb816..dad532ce6148 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -381,6 +381,19 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 	return &hooks->hooks[i];
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+static bool nfqnl_hook_exp_support(const struct nf_hook_ops *ops)
+{
+	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
+		(((ops->pf == NFPROTO_IPV4 ||
+		   ops->pf == NFPROTO_IPV6) &&
+		  (ops->hooknum == NF_INET_LOCAL_IN ||
+		   ops->hooknum == NF_INET_POST_ROUTING)) ||
+		 (ops->pf == NFPROTO_BRIDGE &&
+		  ops->hooknum == NF_BR_POST_ROUTING)));
+}
+#endif
+
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry,
 			const struct nf_hook_entries *hook_entries,
@@ -1826,6 +1839,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
+				      const struct nf_hook_ops *hook,
 				      enum ip_conntrack_info *ctinfo)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -1838,10 +1852,11 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
 		return NULL;
 
-	if (nfqa[NFQA_EXP])
+	if (nfqa[NFQA_EXP] && nfqnl_hook_exp_support(hook)) {
 		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
-				      nlmsg_report(nlh));
+				       NETLINK_CB(entry->skb).portid,
+				       nlmsg_report(nlh));
+	}
 	return ct;
 #else
 	return NULL;
@@ -1937,7 +1952,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
-					    &ctinfo);
+					    hook, &ctinfo);
 	}
 
 	if (entry->state.pf == PF_BRIDGE) {
-- 
2.47.3

