Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95148244671
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915051; cv=none; b=qXQ0aHF5hTy3CprXXYAQcCp5A9fp8F6XywnEhswxT3OpifN9c4XiU9TKzFzwOrI6Xr0VnvwDMNjXpunuUDlhDUdChBiX1/MgRyj1ZiApjDjve0fujLi4/7+hNFUWgQFeLt3UCUeDJQDO4tYcJXiEbxb25F0XjUPZMTc/6z4+ddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915051; c=relaxed/simple;
	bh=uYge2qoJeTVTxB09I1cGTmN1ssAnBlp6sQZnc7Jhs5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/P62jImfXnB+daOkioiqqlPaNNap31ho/NgZDVqTkkC2kWYmFZkCpzwa/w+FhVl2W9c2xkFj3T3sitHlDtE/tGzKd9ARgLVo2Y0fmtYXFcmsj+jLDXu9VMbp/gkZAyoGG9tMsTNySXjqhZuamgZy7JcNi+PUgm8wM1g3F0/pFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ao+UMGt1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ao+UMGt1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758915048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uIPspSLX9lThfAZ+Y5dkohRcaszaIDWglOFteDGsE5E=;
	b=Ao+UMGt1vG4QqB+0kxWoep1nhuV+cSXEreCS2UgBPeo5SFisXjohiklAzlt524TKAI5quV
	8JrLlXuTBlCtozeuEnzyRgxVTuqvTctg0D9g68aYeDIyfvMKUYEx24q+5j8gZ+bzsQD6ew
	LwNRt+0pd9CqCBcDAixnlt0e8Wi4fvI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-hn6MuAqPP_m_w_IXuCNlpQ-1; Fri,
 26 Sep 2025 15:30:45 -0400
X-MC-Unique: hn6MuAqPP_m_w_IXuCNlpQ-1
X-Mimecast-MFC-AGG-ID: hn6MuAqPP_m_w_IXuCNlpQ_1758915044
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B08A319560AE;
	Fri, 26 Sep 2025 19:30:42 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.97])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EFED319560A2;
	Fri, 26 Sep 2025 19:30:37 +0000 (UTC)
From: Ricardo Robaina <rrobaina@redhat.com>
To: audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: paul@paul-moore.com,
	eparis@redhat.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	ej@inai.de,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH v3] audit: include source and destination ports to NETFILTER_PKT
Date: Fri, 26 Sep 2025 16:30:35 -0300
Message-ID: <20250926193035.2158860-1-rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

NETFILTER_PKT records show both source and destination
addresses, in addition to the associated networking protocol.
However, it lacks the ports information, which is often
valuable for troubleshooting.

This patch adds both source and destination port numbers,
'sport' and 'dport' respectively, to TCP, UDP, UDP-Lite and
SCTP-related NETFILTER_PKT records.

 type=NETFILTER_PKT ... saddr=127.0.0.1 daddr=127.0.0.1 proto=icmp
 type=NETFILTER_PKT ... saddr=::1 daddr=::1 proto=ipv6-icmp
 type=NETFILTER_PKT ... daddr=127.0.0.1 proto=udp sport=38173 dport=42424
 type=NETFILTER_PKT ... daddr=::1 proto=udp sport=56852 dport=42424
 type=NETFILTER_PKT ... daddr=127.0.0.1 proto=tcp sport=57022 dport=42424
 type=NETFILTER_PKT ... daddr=::1 proto=tcp sport=50810 dport=42424
 type=NETFILTER_PKT ... daddr=127.0.0.1 proto=sctp sport=54944 dport=42424
 type=NETFILTER_PKT ... daddr=::1 proto=sctp sport=57963 dport=42424

Link: https://github.com/linux-audit/audit-kernel/issues/162
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 net/netfilter/xt_AUDIT.c | 47 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index b6a015aee0ce..fb16f20cfb1b 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <net/ipv6.h>
 #include <net/ip.h>
+#include <linux/sctp.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Graf <tgraf@redhat.com>");
@@ -37,8 +38,27 @@ static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 	if (!ih)
 		return false;
 
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
+	switch (ih->protocol) {
+	case IPPROTO_TCP:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(tcp_hdr(skb)->source), ntohs(tcp_hdr(skb)->dest));
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(udp_hdr(skb)->source), ntohs(udp_hdr(skb)->dest));
+		break;
+	case IPPROTO_SCTP:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(sctp_hdr(skb)->source), ntohs(sctp_hdr(skb)->dest));
+		break;
+	default:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+				 &ih->saddr, &ih->daddr, ih->protocol);
+	}
 
 	return true;
 }
@@ -57,8 +77,27 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	nexthdr = ih->nexthdr;
 	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
 
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(tcp_hdr(skb)->source), ntohs(tcp_hdr(skb)->dest));
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(udp_hdr(skb)->source), ntohs(udp_hdr(skb)->dest));
+		break;
+	case IPPROTO_SCTP:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(sctp_hdr(skb)->source), ntohs(sctp_hdr(skb)->dest));
+		break;
+	default:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+				 &ih->saddr, &ih->daddr, nexthdr);
+	}
 
 	return true;
 }
-- 
2.51.0

