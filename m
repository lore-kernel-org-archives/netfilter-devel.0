Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4A934575D
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041042; cv=none; b=CB5vXim9FCybNHQIOkG3F5yh0oYAmUK/EE9OWADlHeqxCT1pmxy+2N7r0rwdzz9/4QSb4OGwj0sVR39KiRYcN3ZonWjjrtUOFQxHs1v8bXSPyZuiBCy6tTzclRrO+lF2zBfWWzmBQ2BOdMXxJC5EdrybJ3YF5Lx2yD/O8Gbd46Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041042; c=relaxed/simple;
	bh=2FzgnZIQLuOVX0RH5mGPET2t8lF+QMG5icCyZ4hWhW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2raJAkZT5pQ1LmWxNBiSg87/SiaKaCsZquhubbzquITgztENMNpdbTXyk/VQgUYKz2mAFWzwSeg8R9CQ/9T6vjR3KUEn1iJj2/Q8S0ngTgQcivM8gGDUPt3/keIFFpa3ssfayEkjvWBNLhYrmWb6df34WDRmXa183YXqoRFLkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtMlu5Zl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtMlu5Zl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763041040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lG9jBUv4bu7c9vc+o3EVxRmkon7wuELm/GLx4exidZ0=;
	b=WtMlu5ZlR3AX8/vZHNzqEFR6cRnlBD0gELhR0/afGX9hHEw+p8OVUnQ+3Qh9wOtr7H5bSW
	KoV1iEw9CKCoQBGDk7rybF3zAbWaa2sMQx2EXDkb1RGCl0DVLr+q/cRdUbxyxhh/VS2b0A
	mPnKrFlx/Nlj4BOwDL7IXBlrMKNEh80=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-OLyiRvp3OoasHsel3Zt3Lg-1; Thu,
 13 Nov 2025 08:37:17 -0500
X-MC-Unique: OLyiRvp3OoasHsel3Zt3Lg-1
X-Mimecast-MFC-AGG-ID: OLyiRvp3OoasHsel3Zt3Lg_1763041035
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54DE718002FD;
	Thu, 13 Nov 2025 13:37:15 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.76])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A855C1955F1B;
	Thu, 13 Nov 2025 13:37:11 +0000 (UTC)
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
Subject: [PATCH v6 2/2] audit: include source and destination ports to NETFILTER_PKT
Date: Thu, 13 Nov 2025 10:36:56 -0300
Message-ID: <6b1a0c1c964b295d6ecaf9b50b80cbc650e63ba3.1763036807.git.rrobaina@redhat.com>
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

