Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1E2641FB
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919217; cv=none; b=VEo5ncblY5LLnD6DBZHpRw/o1YYbQmxpC0WU/U+4FEyqtqq9BmbbUeJKnwNd5dRwnn5w82T5BsK+VWvP/1MgRaJDjVd4hYoVtgzc/njCALjOlI+qkrBfL39k1ofBEmlSi8DfRgFiKSCTP/ECavwgxb83wSrMaK73Bw1Gz2iPL3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919217; c=relaxed/simple;
	bh=b/+6iLvF/xFmhsioNKUMrHdZw4gUJHtWntWQ72dbIGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajc0vAkRXLWifETt33mhmCjKzHGqM+EGtbuj6xt8ke9RUdcDSYXpFNpecwrb5hUrINx1MyeBGu7rAaKcwToNxlGf3verQCrAWRUbHIbah0fvMdfWL+rYxDO49/iRhCoiGoCv4X10A6EMYbDMTD11PyKE+kk7K6wbAfH3ydO/qBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJmmGElg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJmmGElg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761919214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8zwbPPmLrFrZtU+xz/xV/xP5qAIayjYYUoX61WmiF4=;
	b=cJmmGElgbsVHYRIKcXR16S2YoDTpPvWQBJrs4jlzvaGtCLTBsY5rfbEt/OJKSw/A+hk4td
	d3k9U/kanVLzyarBjmctFhjfT6DV/pURem+ojxz8vBeedehvKn+LC3bhPosck00ExJtL+J
	qbWHqvEtHVXam16chBx5YAUFsTug3Bo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-5czu_u3DO5e7ocy96NwzhQ-1; Fri,
 31 Oct 2025 10:00:08 -0400
X-MC-Unique: 5czu_u3DO5e7ocy96NwzhQ-1
X-Mimecast-MFC-AGG-ID: 5czu_u3DO5e7ocy96NwzhQ_1761919206
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57478195D027;
	Fri, 31 Oct 2025 14:00:05 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.34])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3DF5730001A1;
	Fri, 31 Oct 2025 14:00:00 +0000 (UTC)
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
Subject: [PATCH v4 1/2] audit: add audit_log_packet_ip4 and audit_log_packet_ip6 helper functions
Date: Fri, 31 Oct 2025 10:59:48 -0300
Message-ID: <cfafc5247fbfcd2561de16bcff67c1afd5676c9e.1761918165.git.rrobaina@redhat.com>
In-Reply-To: <cover.1761918165.git.rrobaina@redhat.com>
References: <cover.1761918165.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Netfilter code (net/netfilter/nft_log.c and net/netfilter/xt_AUDIT.c)
have to be kept in sync. Both source files had duplicated versions of
audit_ip4() and audit_ip6() functions, which can result in lack of
consistency and/or duplicated work.

This patch adds two helper functions in audit.c that can be called by
netfilter code commonly, aiming to improve maintainability and
consistency.

Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 include/linux/audit.h    |  2 ++
 kernel/audit.c           | 39 ++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  | 43 ++++------------------------------------
 net/netfilter/xt_AUDIT.c | 43 ++++------------------------------------
 4 files changed, 49 insertions(+), 78 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 536f8ee8da81..5edb83ea63fd 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -195,6 +195,8 @@ extern int audit_log_subj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_obj_ctx(struct audit_buffer *ab, struct lsm_prop *prop);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
+extern bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb);
+extern bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb);
 
 extern int		    audit_update_lsm_rules(void);
 
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
2.51.0

