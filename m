Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2802C348465
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448010; cv=none; b=QvyS3bT1WPVFb8DUTUdkaunBb+3krdR8rKEWtjKlZoMyJeB0kvlSVWNAexPnBnww4zKYi4ThQS3I6yRkLARxX6hYOTs9W7Xo7bPCsBeTt4cVe7+IOiVckBooRC20RgJXgwFbqetWidXzGgPt7eTm4plbe5NSLa5sLtLwGueN3Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448010; c=relaxed/simple;
	bh=pS1lFCWx5tuvC5+eu474zjoAAD+SpYjnhcsbSqP//f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcjNe0XzkW3W0TvMiksedKmrd7ukYwTK2SxWQi9bXzlthFgEnPEMsV1YcFsICgm3hGSZmCFNaXah6X8MaCi0s0C175pnu1qtNUYbeXNLph9WmDtSVv6naNBCNvn3/Qh67W+TRdnsu4oOLks0YkM+aj5xKvJG+17D6sfhezW3i6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKTGhB20; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKTGhB20"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762448007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeA958fGMLqZccrumOoOPagI0ws0mF6lRuKP6lhDsH4=;
	b=MKTGhB20AOHbsEOrBHEkEBTGxUwnboC0WJLCUutLcgNwrZfcaVVa72x4JcE6TvL5hQ4yu+
	zH99ZabPyFuG9CVtSCAxbkgSGSzcrY45e47AF+Qur7XQumnOY1Sox06vWT8CDFKGrc93M8
	Z74TITa9AINxrE2/E7fS9FEBwK5BAWM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-BDqGrPTGOpecwmde_szCIQ-1; Thu,
 06 Nov 2025 11:53:21 -0500
X-MC-Unique: BDqGrPTGOpecwmde_szCIQ-1
X-Mimecast-MFC-AGG-ID: BDqGrPTGOpecwmde_szCIQ_1762448000
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F06E81801235;
	Thu,  6 Nov 2025 16:53:19 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.113])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27DCC18004D8;
	Thu,  6 Nov 2025 16:53:15 +0000 (UTC)
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
Subject: [PATCH v5 1/2] audit: add audit_log_packet_ip4 and audit_log_packet_ip6 helper functions
Date: Thu,  6 Nov 2025 13:53:04 -0300
Message-ID: <acd8109245882afd78cdf2805a2344c20fef1a08.1762434837.git.rrobaina@redhat.com>
In-Reply-To: <cover.1762434837.git.rrobaina@redhat.com>
References: <cover.1762434837.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Netfilter code (net/netfilter/nft_log.c and net/netfilter/xt_AUDIT.c)
have to be kept in sync. Both source files had duplicated versions of
audit_ip4() and audit_ip6() functions, which can result in lack of
consistency and/or duplicated work.

This patch adds two helper functions in audit.c that can be called by
netfilter code commonly, aiming to improve maintainability and
consistency.

Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 include/linux/audit.h    | 12 +++++++++++
 kernel/audit.c           | 39 ++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  | 43 ++++------------------------------------
 net/netfilter/xt_AUDIT.c | 43 ++++------------------------------------
 4 files changed, 59 insertions(+), 78 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 536f8ee8da81..0f16ced08fdb 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -195,6 +195,8 @@ extern int audit_log_subj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_obj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
+extern bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb);
+extern bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -272,6 +274,16 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 static inline void audit_log_task_info(struct audit_buffer *ab)
 { }
 
+static inline bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	return false;
+}
+
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return INVALID_UID;
diff --git a/kernel/audit.c b/kernel/audit.c
index 26a332ffb1b8..09764003db74 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,6 +58,8 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
 
 #include "audit.h"
 
@@ -2538,6 +2540,43 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	audit_log_end(ab);
 }
 
+bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	struct iphdr _iph;
+	const struct iphdr *ih;
+
+	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
+	if (!ih)
+		return false;
+
+	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+			 &ih->saddr, &ih->daddr, ih->protocol);
+
+	return true;
+}
+EXPORT_SYMBOL(audit_log_packet_ip4);
+
+bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	struct ipv6hdr _ip6h;
+	const struct ipv6hdr *ih;
+	u8 nexthdr;
+	__be16 frag_off;
+
+	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
+	if (!ih)
+		return false;
+
+	nexthdr = ih->nexthdr;
+	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
+
+	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+			 &ih->saddr, &ih->daddr, nexthdr);
+
+	return true;
+}
+EXPORT_SYMBOL(audit_log_packet_ip6);
+
 /**
  * audit_set_loginuid - set current task's loginuid
  * @loginuid: loginuid value
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index e35588137995..f53fb4222134 100644
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
@@ -80,18 +45,18 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	case NFPROTO_BRIDGE:
 		switch (eth_hdr(skb)->h_proto) {
 		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+			fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
 			break;
 		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+			fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
 			break;
 		}
 		break;
 	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+		fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
 		break;
 	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+		fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
 		break;
 	}
 
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index b6a015aee0ce..28cdd6435d56 100644
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
@@ -81,18 +46,18 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	case NFPROTO_BRIDGE:
 		switch (eth_hdr(skb)->h_proto) {
 		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+			fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
 			break;
 		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+			fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
 			break;
 		}
 		break;
 	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+		fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
 		break;
 	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+		fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
 		break;
 	}
 
-- 
2.51.1

