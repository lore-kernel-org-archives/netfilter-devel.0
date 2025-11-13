Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2A3385A9
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041038; cv=none; b=kgMbbqRd01Xorw5lMGGNmziXOANAAqtRU0m1S+X5+pJK/RI0j4evjEb9KTMAoIR8JIvH3M53ohQniMZvzzCPpaJ1e+hSaqlK06JDbeKyNx2UqbqsBmB0Ki6KERZDuP4XM8Poi5qJ0vjWTBq4G93HBJ16DHsFN5m+tMwKidJHfCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041038; c=relaxed/simple;
	bh=qyEaCrslf6rLsZ9isUVjwp0fYkUpjlqwLHs8morOrAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKuvCM4rCAk8AFmbb1wWzEWZ05vd5LSL7EcB+rgVxnEvFxdfpQz5LPRYtN/1Z342n9hOV/R1MxSQMGRadVXM7uGucAbk7rPFGGHnERnMMJrppyLnCaH2nTNDeVem5bO71ebP7SSpMrAVZ5E5aIkEkgyrjc9YATrRXahQtRs4z6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SRpYJnGN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRpYJnGN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763041035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1DKUnPwBOkvk/MY/tnTXk7I79eUrCNuPv44C0zl1FHs=;
	b=SRpYJnGNZeT1V0vjUUco64ET6cXFW71biYwpAMqb0pBptFD2qbS+Uc3v+4/fUo+iIIVkgF
	JDrnwCQ2Z39TS7vnZFkz8O5jBVrm/rqJm7yyff8DN0I55ukBeq7eBcxBseSB5fnyiVY3+W
	ZzGuxQQYeUncj/NerwRkwq3cATIjklg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-QEvQRCD0NBG9BVv0mOW5sQ-1; Thu,
 13 Nov 2025 08:37:12 -0500
X-MC-Unique: QEvQRCD0NBG9BVv0mOW5sQ-1
X-Mimecast-MFC-AGG-ID: QEvQRCD0NBG9BVv0mOW5sQ_1763041031
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C28F19560B6;
	Thu, 13 Nov 2025 13:37:11 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.76])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D3561955F1B;
	Thu, 13 Nov 2025 13:37:06 +0000 (UTC)
From: Ricardo Robaina <rrobaina@redhat.com>
To: audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: paul@paul-moore.com,
	eparis@redhat.com,
	fw@strlen.de,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH v6 1/2] audit: add audit_log_nf_skb helper function
Date: Thu, 13 Nov 2025 10:36:55 -0300
Message-ID: <589b485078a65c766bcdee2fd9881c540813f8c5.1763036807.git.rrobaina@redhat.com>
In-Reply-To: <cover.1763036807.git.rrobaina@redhat.com>
References: <cover.1763036807.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Netfilter code (net/netfilter/nft_log.c and net/netfilter/xt_AUDIT.c)
have to be kept in sync. Both source files had duplicated versions of
audit_ip4() and audit_ip6() functions, which can result in lack of
consistency and/or duplicated work.

This patch adds a helper function in audit.c that can be called by
netfilter code commonly, aiming to improve maintainability and
consistency.

Suggested-by: Florian Westphal <fw@strlen.de>
Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 include/linux/audit.h    |  8 +++++
 kernel/audit.c           | 64 ++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  | 57 +----------------------------------
 net/netfilter/xt_AUDIT.c | 57 +----------------------------------
 4 files changed, 74 insertions(+), 112 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 536f8ee8da81..d8173af498ba 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -195,6 +195,8 @@ extern int audit_log_subj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_obj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
+extern int audit_log_nf_skb(struct audit_buffer *ab,
+			    const struct sk_buff *skb, u8 nfproto);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -272,6 +274,12 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab)
 { }
 
+static inline int audit_log_nf_skb(struct audit_buffer *ab,
+				   const struct sk_buff *skb, u8 nfproto)
+{
+	return 0;
+}
+
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return INVALID_UID;
diff --git a/kernel/audit.c b/kernel/audit.c
index 26a332ffb1b8..5c302c4592db 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,6 +58,8 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
 
 #include "audit.h"
 
@@ -2488,6 +2490,68 @@ void audit_log_path_denied(int type, const char *operation)
 	audit_log_end(ab);
 }
 
+int audit_log_nf_skb(struct audit_buffer *ab,
+		     const struct sk_buff *skb, u8 nfproto)
+{
+	/* find the IP protocol in the case of NFPROTO_BRIDGE */
+	if (nfproto == NFPROTO_BRIDGE) {
+		switch (eth_hdr(skb)->h_proto) {
+		case htons(ETH_P_IP):
+			nfproto = NFPROTO_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			nfproto = NFPROTO_IPV6;
+			break;
+		default:
+			goto unknown_proto;
+		}
+	}
+
+	switch (nfproto) {
+	case NFPROTO_IPV4: {
+		struct iphdr iph;
+		const struct iphdr *ih;
+
+		ih = skb_header_pointer(skb, skb_network_offset(skb),
+					sizeof(iph), &iph);
+		if (!ih)
+			return -ENOMEM;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+				 &ih->saddr, &ih->daddr, ih->protocol);
+		break;
+	}
+	case NFPROTO_IPV6: {
+		struct ipv6hdr iph;
+		const struct ipv6hdr *ih;
+		u8 nexthdr;
+		__be16 frag_off;
+
+		ih = skb_header_pointer(skb, skb_network_offset(skb),
+					sizeof(iph), &iph);
+		if (!ih)
+			return -ENOMEM;
+
+		nexthdr = ih->nexthdr;
+		ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(iph),
+				 &nexthdr, &frag_off);
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+				 &ih->saddr, &ih->daddr, nexthdr);
+		break;
+	}
+	default:
+		goto unknown_proto;
+	}
+
+	return 0;
+
+unknown_proto:
+	audit_log_format(ab, " saddr=? daddr=? proto=?");
+	return -EPFNOSUPPORT;
+}
+EXPORT_SYMBOL(audit_log_nf_skb);
+
 /* global counter which is incremented every time something logs in */
 static atomic_t session_id = ATOMIC_INIT(0);
 
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index e35588137995..cd4fc175d9e4 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -26,41 +26,6 @@ struct nft_log {
 	char			*prefix;
 };
 
-static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct iphdr _iph;
-	const struct iphdr *ih;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
-	if (!ih)
-		return false;
-
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
-
-	return true;
-}
-
-static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct ipv6hdr _ip6h;
-	const struct ipv6hdr *ih;
-	u8 nexthdr;
-	__be16 frag_off;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih)
-		return false;
-
-	nexthdr = ih->nexthdr;
-	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
-
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
-
-	return true;
-}
-
 static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 {
 	struct sk_buff *skb = pkt->skb;
@@ -76,27 +41,7 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
-	switch (nft_pf(pkt)) {
-	case NFPROTO_BRIDGE:
-		switch (eth_hdr(skb)->h_proto) {
-		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-			break;
-		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-			break;
-		}
-		break;
-	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-		break;
-	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-		break;
-	}
-
-	if (fam == -1)
-		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	audit_log_nf_skb(ab, skb, nft_pf(pkt));
 
 	audit_log_end(ab);
 }
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index b6a015aee0ce..6881a7833707 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -28,41 +28,6 @@ MODULE_ALIAS("ip6t_AUDIT");
 MODULE_ALIAS("ebt_AUDIT");
 MODULE_ALIAS("arpt_AUDIT");
 
-static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct iphdr _iph;
-	const struct iphdr *ih;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
-	if (!ih)
-		return false;
-
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
-
-	return true;
-}
-
-static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct ipv6hdr _ip6h;
-	const struct ipv6hdr *ih;
-	u8 nexthdr;
-	__be16 frag_off;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih)
-		return false;
-
-	nexthdr = ih->nexthdr;
-	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
-
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
-
-	return true;
-}
-
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -77,27 +42,7 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
-	switch (xt_family(par)) {
-	case NFPROTO_BRIDGE:
-		switch (eth_hdr(skb)->h_proto) {
-		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-			break;
-		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-			break;
-		}
-		break;
-	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-		break;
-	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-		break;
-	}
-
-	if (fam == -1)
-		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	audit_log_nf_skb(ab, skb, xt_family(par));
 
 	audit_log_end(ab);
 
-- 
2.51.1

