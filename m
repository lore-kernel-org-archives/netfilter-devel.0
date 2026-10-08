Received: from cvsmtppost13.nm.naver.com (cvsmtppost13.nm.naver.com [114.111.35.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D0547075
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 05:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791436366; cv=none; b=OiDL3iJMu20U9KbQb5YK5SIV2/PEU5noaJfMqe9Cztc50hQ9mpHMCpSeNB7GZIwZyBQ4ZcVRSmRlZ7M+RVvvOELVaxOZ3pkY6Ox567RZgylZvitPzmzgvCYI2HCo/vHqAoBsDyXoXIYc83xttGi51NeJ6gkz7ScTfEhaSkezM64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791436366; c=relaxed/simple;
	bh=QjRwAH8htDnUqAgWGHR86PsqrL3WAOVeYSL+BLIOoOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvJ9Z/rHMRN0EjJGTlPGFVpsJFoOUKrmsBMbiEpnTtkldTQhssZkVi+kOJ8GgrQKqOvL/xjYIhhVXfHX94DAIBa8acoGNTR9NtaKrAfvJS5FGvJkZlu1PhmPbMUi6muW+fKqOJ2haVjTeMrHNB4KWLfvzzfqJXTffndUP7Ki/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=jNxPkB1O; arc=none smtp.client-ip=114.111.35.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="jNxPkB1O"
Received: from cvsendbo023.nm ([10.112.22.35])
  by cvsmtppost13.nm.naver.com with ESMTP id tasbd4cVR3KQrUNbmb3gIQ
  for <netfilter-devel@vger.kernel.org>;
  Thu, 08 Oct 2026 05:02:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791435755; bh=QjRwAH8htDnUqAgWGHR86PsqrL3WAOVeYSL+BLIOoOc=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=jNxPkB1ObuQCTA17Tc9ydfOrsuFe/vStiuKY6cNH0GO6Q9SYKkm4sgHgnf0wHSYg9
	 85uBRWsleVdinITuYJ9f7CTiGpQ0YFDZp0nfv6UVpn/fxKwiazgr/9C8C9nsw8lug+
	 Kcjpa3lpM3BLh/75C/5JQ6/f/tyMscQZ4KcQSW2yOAaOLdjDA1+9n6sW15V/vQYcQE
	 BclfKDof20yZghZTnzeDGirBh+EM2Tits711wqEYq9A4XFtqJTXnKtc3m/4t/Cjnbr
	 6SUds+0pJlzbaJ0H0GHWUdKl7Z5pRpIAW4DqizrK4QF6C3Qmcvfez3z2MJsTFLp+ny
	 wJS1LwLeP1CxA==
X-Session-ID: Q-gMG+F9Royi47dWXuXcFw
X-Works-Send-Opt: OsRwpzGdjHmdKHFOMr39Ko3YKBmljAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: rZYmFAulFqJZ+HmdFxKq+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by mvnsmtp06.nm.naver.com with ESMTP id Q-gMG+F9Royi47dWXuXcFw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 08 Oct 2026 05:02:34 -0000
From: sung byeongchan <tjdqudcks0424@naver.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>
Subject: [PATCH net v2] netfilter: nf_conntrack_reasm: avoid truncating header offsets
Date: Thu,  8 Oct 2026 14:02:25 +0900
Message-ID: <20261008050225.29543-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929090027.200041-1-tjdqudcks0424@naver.com>
References: <20260929090027.200041-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: 성병찬 <tjdqudcks0424@naver.com>

find_prev_fhdr() stores the offset of the previous Next Header field in
an 8-bit variable. A valid IPv6 extension header chain can place that
field at offset 256, causing the value to wrap to zero. Reassembly then
writes the Fragment Header's next-header value to the wrong byte.

Use int for prev_nhoff so the offset is preserved until it is checked by
its consumer.

The same path also passes an unchecked offset to two 16-bit consumers:
frag_queue.nhoffset and skb->transport_header. On the LOCAL_OUT raw path,
a 65536-byte IPv6 packet can place the Fragment Header at offset 65528.
With 16 bytes of skb headroom, skb_set_transport_header() truncates 65544
to 8. In the reproduced path, reassembly subsequently passes -8 as the
unsigned skb_push() length and triggers skb_under_panic().

Reject a previous-header offset that cannot be represented by nhoffset,
and use skb_set_transport_header_careful() to reject a Fragment Header
offset that cannot be represented relative to skb->head.

The prev_nhoff widening was previously posted by Jérémy Jean. This
revision folds it together with the remaining 16-bit checks, as requested
by Pablo Neira Ayuso.

The 16-bit transport-header failure reproduced on three independent
boots, including one run from outer UID 65534 in new user and network
namespaces. With the combined fix, the trigger was rejected safely in
three runs. Short fragments, ordinary IPv6 TCP and UDP, and the earlier
offset-248 and offset-256 cases continued to work.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Link: https://lore.kernel.org/netfilter-devel/20260822214012.1028305-2-Jeremy.Jean@oss.cyber.gouv.fr/
Link: https://lore.kernel.org/netfilter-devel/179089937913.434549.5874493628033954656@kernel.org/
Cc: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
---
Changes in v2:
- Fold the remaining u16 nhoffset and transport-header checks into the
  prev_nhoff fix, as requested by Pablo Neira Ayuso.
- Add the three-run crash and fixed A/B results.
- Credit Jérémy Jean's earlier posting of the prev_nhoff widening.

 net/ipv6/netfilter/nf_conntrack_reasm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49bf0a0a..ae25ebc873b0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 {
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 	const int netoff = skb_network_offset(skb);
-	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
+	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
 	int start = netoff + sizeof(struct ipv6hdr);
 	int len = skb->len - start;
 	u8 prevhdr = NEXTHDR_IPV6;
@@ -474,7 +474,9 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
 		return -ENOMEM;
 
-	skb_set_transport_header(skb, fhoff);
+	if (nhoff != (u16)nhoff ||
+	    !skb_set_transport_header_careful(skb, fhoff))
+		return -EINVAL;
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
base-commit: 6d25ffca055a77787c21a36b66c253f76239411b
-- 
2.43.0

