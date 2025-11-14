Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12923D7F0
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123801; cv=none; b=WS8eq0XTX11BlGkO5f0eDqPIZTBBG2wOdfSYvxmPXwuTJAVzrGUPeEys2f7Xu7GhtY7OFMh0/DDD0wzYAwzirrwRzIZyeCLwvn1U1WWSPY+1WNR6MQJ4HL/6l/bftBVf3rIqoHOObFQx8TSnEj1AprMus7o6Iqixm3hBklzMA/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123801; c=relaxed/simple;
	bh=2FzgnZIQLuOVX0RH5mGPET2t8lF+QMG5icCyZ4hWhW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhuVrmn8vXqXJLj5Nl/v5/WNxoVC5ja8jvKVoUWIxr9nfIWpbeZdG3tfJS/QTewH6CBT1aypkekirDNGwM+KnNVR6lY5N67SIiOZZMGW7Gd0VdvALqsHYUdusrauE7xYikHqLLixlSCIx+fIxSAYW9L9QR0s5v57M/+HCieWG9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aP9TImmD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aP9TImmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763123798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lG9jBUv4bu7c9vc+o3EVxRmkon7wuELm/GLx4exidZ0=;
	b=aP9TImmD4u9i8Bd8fTa1EkNtf1pGbgmQrsCgtzZ9zypyHWSP99APMEIrPW9KeXATEpsIhk
	1838SuhQxXKkjlmGbk2Xk6H5TeSUu2+WxJUJE5SosaXymj/MNJtmcRnVzshDMwJGGXUn8g
	g0A48iD3rH/gFkjKyxxFmeLRcCTQI5c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-fZG_BpHhNRiVWZJyZCakSw-1; Fri,
 14 Nov 2025 07:36:35 -0500
X-MC-Unique: fZG_BpHhNRiVWZJyZCakSw-1
X-Mimecast-MFC-AGG-ID: fZG_BpHhNRiVWZJyZCakSw_1763123793
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EBBB19560AA;
	Fri, 14 Nov 2025 12:36:33 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.52])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D67821800949;
	Fri, 14 Nov 2025 12:36:29 +0000 (UTC)
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
Subject: [PATCH v7 2/2] audit: include source and destination ports to NETFILTER_PKT
Date: Fri, 14 Nov 2025 09:36:17 -0300
Message-ID: <0fb9e8efdc66c2bbd3d9b81e808c58407f7b4b68.1763122537.git.rrobaina@redhat.com>
In-Reply-To: <cover.1763122537.git.rrobaina@redhat.com>
References: <cover.1763122537.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 kernel/audit.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5c302c4592db..39c4f26c484d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -60,6 +60,7 @@
 #include <net/netns/generic.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <linux/sctp.h>
 
 #include "audit.h"
 
@@ -2517,8 +2518,55 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 		if (!ih)
 			return -ENOMEM;
 
-		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-				 &ih->saddr, &ih->daddr, ih->protocol);
+		switch (ih->protocol) {
+		case IPPROTO_TCP: {
+			struct tcphdr _tcph;
+			const struct tcphdr *th;
+
+			th = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_tcph), &_tcph);
+			if (!th)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, ih->protocol,
+					 ntohs(th->source), ntohs(th->dest));
+			break;
+		}
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE: {
+			struct udphdr _udph;
+			const struct udphdr *uh;
+
+			uh = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_udph), &_udph);
+			if (!uh)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, ih->protocol,
+					 ntohs(uh->source), ntohs(uh->dest));
+			break;
+		}
+		case IPPROTO_SCTP: {
+			struct sctphdr _sctph;
+			const struct sctphdr *sh;
+
+			sh = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_sctph), &_sctph);
+			if (!sh)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, ih->protocol,
+					 ntohs(sh->source), ntohs(sh->dest));
+			break;
+		}
+		default:
+			audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+					 &ih->saddr, &ih->daddr, ih->protocol);
+		}
+
 		break;
 	}
 	case NFPROTO_IPV6: {
@@ -2536,8 +2584,55 @@ int audit_log_nf_skb(struct audit_buffer *ab,
 		ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(iph),
 				 &nexthdr, &frag_off);
 
-		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-				 &ih->saddr, &ih->daddr, nexthdr);
+		switch (nexthdr) {
+		case IPPROTO_TCP: {
+			struct tcphdr _tcph;
+			const struct tcphdr *th;
+
+			th = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_tcph), &_tcph);
+			if (!th)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, nexthdr,
+					 ntohs(th->source), ntohs(th->dest));
+			break;
+		}
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE: {
+			struct udphdr _udph;
+			const struct udphdr *uh;
+
+			uh = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_udph), &_udph);
+			if (!uh)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, nexthdr,
+					 ntohs(uh->source), ntohs(uh->dest));
+			break;
+		}
+		case IPPROTO_SCTP: {
+			struct sctphdr _sctph;
+			const struct sctphdr *sh;
+
+			sh = skb_header_pointer(skb, skb_transport_offset(skb),
+						sizeof(_sctph), &_sctph);
+			if (!sh)
+				return -ENOMEM;
+
+			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu sport=%hu dport=%hu",
+					 &ih->saddr, &ih->daddr, nexthdr,
+					 ntohs(sh->source), ntohs(sh->dest));
+			break;
+		}
+		default:
+			audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+					 &ih->saddr, &ih->daddr, nexthdr);
+		}
+
 		break;
 	}
 	default:
-- 
2.51.1

