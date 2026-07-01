Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FF523E342
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 06:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887372; cv=none; b=S7ce5204fRGM/4V4PD1Y4uc4mQxOpOwCufGOJ+dy9upcdqzAHDSEOxrNp7f6g71ftf/7NXNUvcPMSO7dM9HLDaAr11Wbd5Eu8VBqF4ene8xqNAqrhX9UmJTIkd8x36BXzFV0OkQa2dTsbMuBNZIvvAC6TvTEcpxzZDun7nP/pns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887372; c=relaxed/simple;
	bh=3/MRws6i3Oc7nSbjZm0ZhsGGvez3dS4X99N6foXkRcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFrSuBanHsngUARcTF+6+UwjH6oc03Jl3XkHMoqx6GKc3HrnxgnK9PphutRbZTFv0gaRezk8YbHQolLHorB3+jCo3MqfDcecSroWZ+xa0/A3wwozkSFY5wvfHKXO3jnASMPkFJ1Ei2FtQXt/4tBCtKNbbuLexjmDzSfyxtSyOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9269A602F8; Wed, 01 Jul 2026 08:29:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_nat_sip: reload possible stale data pointer
Date: Wed,  1 Jul 2026 08:29:22 +0200
Message-ID: <20260701062922.9660-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

quoting sashiko:
-------------------------------------------------------------------------
[..] noticed a potential memory bug and header corruption involving the
SIP NAT helper.

In net/netfilter/nf_nat_sip.c:nf_nat_sip():
	if (skb_ensure_writable(skb, skb->len)) {
		nf_ct_helper_log(skb, ct, "cannot mangle packet");
		return NF_DROP;
	}
	uh = (void *)skb->data + protoff;
	uh->dest = ct_sip_info->forced_dport;
	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo, protoff,
				      0, 0, NULL, 0)) {

If a cloned or fragmented SKB is reallocated by skb_ensure_writable(), the
old data buffer is freed. However, nf_nat_sip() fails to update *dptr to
point to the new buffer.

It also appears to use nf_nat_mangle_udp_packet() on what could be a TCP
packet, which would overwrite the sequence number with a checksum update.
-------------------------------------------------------------------------

nf_conntrack_sip linerizes skbs, hence no fragmented skb can be seen.
But clones are possible, so rebuild dptr.

Disable nf_nat_mangle_udp_packet() branch for TCP streams.
It doesn't look like this can ever happen, else we should have received
bug reports about this, so just check the conntrack is UDP and drop
otherwise.

The calling conntrack_sip set ->forced_dport for SIP_HDR_VIA_UDP messages,
so I don't think this is ever expected to be true for a TCP stream.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_sip.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 67c04d8143ab..f4dd5719c797 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -289,13 +289,25 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 
 	/* Mangle destination port for Cisco phones, then fix up checksums */
 	if (dir == IP_CT_DIR_REPLY && ct_sip_info->forced_dport) {
+		int doff = *dptr - (const char *)skb->data;
 		struct udphdr *uh;
 
+		if (doff <= 0) {
+			DEBUG_NET_WARN_ON_ONCE(1);
+			return NF_DROP;
+
+		}
+
+		/* ct_sip_info->forced_dport only expected with UDP */
+		if (nf_ct_protonum(ct) != IPPROTO_UDP)
+			return NF_DROP;
+
 		if (skb_ensure_writable(skb, skb->len)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle packet");
 			return NF_DROP;
 		}
 
+		*dptr = skb->data + doff;
 		uh = (void *)skb->data + protoff;
 		uh->dest = ct_sip_info->forced_dport;
 
-- 
2.54.0

