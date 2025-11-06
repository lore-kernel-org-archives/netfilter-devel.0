Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDAE347BBE
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448009; cv=none; b=KWSBY6S9wW0+73yXDyDd/YikKydrl0KoJeHoU5HYpMwUUdIaRYCQtUQuAL1yMToRys4RdS0imeB2Vi0ZhwLAwTdT2vSA6IIDcXZXqoFTb0EI6/ykmQkKQePzy9RdWSWlQdPQd7pt0r96cldmToYAoKbiyP+u7aBSyE6E4rqLB/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448009; c=relaxed/simple;
	bh=xcI3fxWr3wsaBdkMdmkh8A2alUjJf+s4H+Q9lIEQ9jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxKOOVVkmKb1RYOzcBTqT0X08k7JlyrTGnoi4JxfiB0izQRBeRp1sUhb3+LxEB4cwbZnVls0V9L/NniRxhsXShYNucCJF2n0YV3F1f+h/zb0iYnF21mZGTrkCYr0CGCFHq8tM1ar+u+I+uSMUrBwPQOe7sPHMARDA5N2wZOkaMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bh9nnNno; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bh9nnNno"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762448006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=so0OXNKYddzfc7/g5QVtuwqh5H9GBtOvc8rrxcPEA+U=;
	b=bh9nnNnoKX5nwCS0yoFie6tYvvA7fW56uT6OFvv6B94ttPqSBwGwXV/AleYzYEsvYq5PG4
	Mryd/EaE3ydewxI7ZjPQTGks9i3yBoe+10+TQQNIhKXaugtlRNNpuj23xPnBzjeFYX+l3u
	YKw8ajdohCAtDBorRgWJRDP/xl86Yl4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-aE-lWsyyMai9jL-XEYDmLg-1; Thu,
 06 Nov 2025 11:53:25 -0500
X-MC-Unique: aE-lWsyyMai9jL-XEYDmLg-1
X-Mimecast-MFC-AGG-ID: aE-lWsyyMai9jL-XEYDmLg_1762448004
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD50B195609F;
	Thu,  6 Nov 2025 16:53:23 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.113])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 746E31800584;
	Thu,  6 Nov 2025 16:53:20 +0000 (UTC)
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
Subject: [PATCH v5 2/2] audit: include source and destination ports to NETFILTER_PKT
Date: Thu,  6 Nov 2025 13:53:05 -0300
Message-ID: <b44ec08fbb011bc73ad2760676e0bbfda2ca9585.1762434837.git.rrobaina@redhat.com>
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

NETFILTER_PKT records show both source and destination
addresses, in addition to the associated networking protocol.
However, it lacks the ports information, which is often
valuable for troubleshooting.

This patch adds both source and destination port numbers,
'sport' and 'dport' respectively, to TCP, UDP, UDP-Lite and
SCTP-related NETFILTER_PKT records.

 $ TESTS="netfilter_pkt" make -e test &> /dev/null
 $ ausearch -i -ts recent |grep NETFILTER_PKT
 type=NETFILTER_PKT ... proto=icmp
 type=NETFILTER_PKT ... proto=ipv6-icmp
 type=NETFILTER_PKT ... proto=udp sport=46333 dport=42424
 type=NETFILTER_PKT ... proto=udp sport=35953 dport=42424
 type=NETFILTER_PKT ... proto=tcp sport=50314 dport=42424
 type=NETFILTER_PKT ... proto=tcp sport=57346 dport=42424

Link: https://github.com/linux-audit/audit-kernel/issues/162

Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 kernel/audit.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09764003db74..71dcadf12c99 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -60,6 +60,7 @@
 #include <net/netns/generic.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <linux/sctp.h>
 
 #include "audit.h"
 
@@ -2544,13 +2545,50 @@ bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct iphdr _iph;
 	const struct iphdr *ih;
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
+	struct udphdr _udph;
+	const struct udphdr *uh;
+	struct sctphdr _sctph;
+	const struct sctphdr *sh;
 
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
 	if (!ih)
 		return false;
 
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
+	switch (ih->protocol) {
+	case IPPROTO_TCP:
+		th = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_tcph), &_tcph);
+		if (!th)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(th->source), ntohs(th->dest));
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
+		if (!uh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(uh->source), ntohs(uh->dest));
+		break;
+	case IPPROTO_SCTP:
+		sh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_sctph), &_sctph);
+		if (!sh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(sh->source), ntohs(sh->dest));
+		break;
+	default:
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+				 &ih->saddr, &ih->daddr, ih->protocol);
+	}
 
 	return true;
 }
@@ -2562,6 +2600,12 @@ bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	const struct ipv6hdr *ih;
 	u8 nexthdr;
 	__be16 frag_off;
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
+	struct udphdr _udph;
+	const struct udphdr *uh;
+	struct sctphdr _sctph;
+	const struct sctphdr *sh;
 
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
 	if (!ih)
@@ -2570,8 +2614,39 @@ bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	nexthdr = ih->nexthdr;
 	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
 
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		th = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_tcph), &_tcph);
+		if (!th)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(th->source), ntohs(th->dest));
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
+		if (!uh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(uh->source), ntohs(uh->dest));
+		break;
+	case IPPROTO_SCTP:
+		sh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_sctph), &_sctph);
+		if (!sh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(sh->source), ntohs(sh->dest));
+		break;
+	default:
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+				 &ih->saddr, &ih->daddr, nexthdr);
+	}
 
 	return true;
 }
-- 
2.51.1

