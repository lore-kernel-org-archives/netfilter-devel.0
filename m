Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F2A41
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919221; cv=none; b=jQapw1z3BdcXXtSvQq4R0dRMXQhzm4Z0dRzPKlWINXiHD4JvU5cyZYpDqHoiu63zSFyTUynMXTUl7krG4278GSoYM7vfr4G0hcWCIXWl2Px83zYGOnz/EnLnlW3dio5XAVKGY0+RA4EruTW8DCeT2buFy9yZd8r7SoVMZzOLi+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919221; c=relaxed/simple;
	bh=gTv+1XYS68MHjfM6eRnKlVdpGjF97WurU9JJNgPdgyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS2SZ498ARIo+DBMZmahxCvU5xlDSJJoPbmAghI4Dqjd3HGc41tAgzvfITDSykBPV0isbdZpKEMMfsrtzi0vZLLx14OtsWr8C0OW8Y2fDWAtH+K6C9BHyeJ5S6Spl8MUdzr+CRQAgmwi9MUuuaN0dGbtuxMGVi3MztDwvA0Uths=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSEwQ2Es; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSEwQ2Es"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761919218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2nsxAfyFQGcQDUzbfJSVcwzg7l0EV9eoFEzO37AiGT0=;
	b=dSEwQ2Es/i5GEAnCbj8C8CEsebeIEqrTRMtPlHQ+849YXM0nPsDodk7hBvD4Z7uJ/3pv43
	kCTLiQVgUuBvMWpQkvmwXR69vo2l/WzsnUeVi7JjoP+7gtjKkfKXAXi3wbOe9YolfiaAI5
	Comfgehb8P7ZmWZJzp2G3qEbeubOmwQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-RyMIFsNlOnyVG7oEDMfYWA-1; Fri,
 31 Oct 2025 10:00:15 -0400
X-MC-Unique: RyMIFsNlOnyVG7oEDMfYWA-1
X-Mimecast-MFC-AGG-ID: RyMIFsNlOnyVG7oEDMfYWA_1761919210
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 477161954B05;
	Fri, 31 Oct 2025 14:00:10 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.34])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28A5530001A8;
	Fri, 31 Oct 2025 14:00:05 +0000 (UTC)
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
Subject: [PATCH v4 2/2] audit: include source and destination ports to NETFILTER_PKT
Date: Fri, 31 Oct 2025 10:59:49 -0300
Message-ID: <6ac2baf0d5ae176cbd3279a4dff9e2c7750c6d45.1761918165.git.rrobaina@redhat.com>
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
 kernel/audit.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09764003db74..bc7217402a35 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -60,6 +60,7 @@
 #include <net/netns/generic.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <linux/sctp.h>
 
 #include "audit.h"
 
@@ -2549,8 +2550,48 @@ bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 	if (!ih)
 		return false;
 
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
+	switch (ih->protocol) {
+	case IPPROTO_TCP:
+		struct tcphdr _tcph;
+		const struct tcphdr *th;
+
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
+		struct udphdr _udph;
+		const struct udphdr *uh;
+
+		uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
+		if (!uh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, ih->protocol,
+				 ntohs(uh->source), ntohs(uh->dest));
+		break;
+	case IPPROTO_SCTP:
+		struct sctphdr _sctph;
+		const struct sctphdr *sh;
+
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
@@ -2570,8 +2611,48 @@ bool audit_log_packet_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 	nexthdr = ih->nexthdr;
 	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
 
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		struct tcphdr _tcph;
+		const struct tcphdr *th;
+
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
+		struct udphdr _udph;
+		const struct udphdr *uh;
+
+		uh = skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_udph), &_udph);
+		if (!uh)
+			return false;
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+				 &ih->saddr, &ih->daddr, nexthdr,
+				 ntohs(uh->source), ntohs(uh->dest));
+		break;
+	case IPPROTO_SCTP:
+		struct sctphdr _sctph;
+		const struct sctphdr *sh;
+
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
2.51.0

