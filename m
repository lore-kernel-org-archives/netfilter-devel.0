Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31C23176F2
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2025 20:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758571799; cv=none; b=IG04PxeimfmD7SK8u4Fdrc0t3Mpa8yPpCKz562yrN0cpdTJJm5U0KR9MtIdc6UpUMdlOVlgpSqT4ec6PhDQlVba69WZiaceZq5fw11kFUCOYJBJuuRJUBDN94657BOFaDlMJsHf0YUek5lpa2MY2RemITetaiMpm/GkPrK53LRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758571799; c=relaxed/simple;
	bh=96yc8lr8zpTTnNLo+57UwK0ZN6gWSNcoPPMe554q/80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R6vb9kzNmI9d4E8uYFZ4hRZgcCjWMCoHdfY8qBCxJZofOyFGMaSpHwjK6875Q9G0oyLxGtqPtVbk5KfWu3due7g97ZqalNMpppVYMoZlbAJlhBBpoqzOUpAX8Tjkg0tVMzJub4tnXSDs9IREYOFLqURaFUy+53xq81c7wXjAzN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SSZMeOT2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SSZMeOT2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758571796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xMy9+5cJFf4QAOot9A0fSaZyvFYitQlYRC/JRAHzUU8=;
	b=SSZMeOT2y+hRg1l/qA9L0kFm4uIVDI2gcNYKx7BCH0wZmiZlZXbLjlqHBE4wi2jX5DjLS9
	MhLYW500IBA+PcG/HBIuV3t9+GRDlM33xpUxyzbrZQH7MTCBD4Y+GKC9VfzAoh/KLx0Jiy
	FkvxdqK5pXQib6RedJq3AB6GAjqiRhY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-RCZSE8ExNDun-yru0aRLLA-1; Mon,
 22 Sep 2025 16:09:53 -0400
X-MC-Unique: RCZSE8ExNDun-yru0aRLLA-1
X-Mimecast-MFC-AGG-ID: RCZSE8ExNDun-yru0aRLLA_1758571791
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 131E119560AE;
	Mon, 22 Sep 2025 20:09:51 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F8A41956045;
	Mon, 22 Sep 2025 20:09:46 +0000 (UTC)
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
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH v1] audit: include source and destination ports to NETFILTER_PKT
Date: Mon, 22 Sep 2025 17:09:42 -0300
Message-ID: <20250922200942.1534414-1-rrobaina@redhat.com>
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
'sport' and 'dport' respectively, only to tcp/udp-related
NETFILTER_PKT records.

 # ./audit-testsuite/tests/netfilter_pkt/test &> /dev/null
 # ausearch -i -m netfilter_pkt |tail -n12
 type=NETFILTER_PKT ... saddr=127.0.0.1 daddr=127.0.0.1 proto=icmp
 ----
 type=NETFILTER_PKT ... saddr=::1 daddr=::1 proto=ipv6-icmp
 ----
 type=NETFILTER_PKT ... daddr=127.0.0.1 proto=udp sport=38173 dport=42424
 ----
 type=NETFILTER_PKT ... daddr=::1 proto=udp sport=56852 dport=42424
 ----
 type=NETFILTER_PKT ... daddr=127.0.0.1 proto=tcp sport=57022 dport=42424
 ----
 type=NETFILTER_PKT ... daddr=::1 proto=tcp sport=50810 dport=42424

Link: https://github.com/linux-audit/audit-kernel/issues/162
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 net/netfilter/xt_AUDIT.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index b6a015aee0ce..96a18675d468 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -32,6 +32,7 @@ static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct iphdr _iph;
 	const struct iphdr *ih;
+	__be16 dport, sport;
 
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
 	if (!ih)
@@ -40,6 +41,19 @@ static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
 			 &ih->saddr, &ih->daddr, ih->protocol);
 
+	switch (ih->protocol) {
+	case IPPROTO_TCP:
+		sport = tcp_hdr(skb)->source;
+		dport = tcp_hdr(skb)->dest;
+		break;
+	case IPPROTO_UDP:
+		sport = udp_hdr(skb)->source;
+		dport = udp_hdr(skb)->dest;
+	}
+
+	if (ih->protocol == IPPROTO_TCP || ih->protocol == IPPROTO_UDP)
+		audit_log_format(ab, " sport=%hu dport=%hu", ntohs(sport), ntohs(dport));
+
 	return true;
 }
 
@@ -48,7 +62,7 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	struct ipv6hdr _ip6h;
 	const struct ipv6hdr *ih;
 	u8 nexthdr;
-	__be16 frag_off;
+	__be16 frag_off, dport, sport;
 
 	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
 	if (!ih)
@@ -60,6 +74,19 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
 			 &ih->saddr, &ih->daddr, nexthdr);
 
+	switch (ih->nexthdr) {
+	case IPPROTO_TCP:
+		sport = tcp_hdr(skb)->source;
+		dport = tcp_hdr(skb)->dest;
+		break;
+	case IPPROTO_UDP:
+		sport = udp_hdr(skb)->source;
+		dport = udp_hdr(skb)->dest;
+	}
+
+	if (ih->nexthdr == IPPROTO_TCP || ih->nexthdr == IPPROTO_UDP)
+		audit_log_format(ab, " sport=%hu dport=%hu", ntohs(sport), ntohs(dport));
+
 	return true;
 }
 
-- 
2.51.0

