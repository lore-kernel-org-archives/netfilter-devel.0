Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E505391E4E;
	Sat, 22 Aug 2026 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787434857; cv=none; b=keT7YU/pFNSJrGhFrIVvJr7q/xOPdN4Opc/k+xyCoNKw12t4+Qu/0pneEsac57xYOg3ihmWg03zlLu9noMGi/rdRZ+dE7vTnmKa4ZW1wl+15ByNq0Erm6CLl7FYY2Qld7+Z84e4op3Pc6Inidr8Tdtwk6Mf9QIqayRXQf7ifVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787434857; c=relaxed/simple;
	bh=A4s3UTiN8VWGIBo1FYs2EtBsQgxLARFTAbxUCm64UX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L8p//ljvtNsEiFTizdeEjDD/ccA5uAqJtB3gbkusvtRSttpnAxwjmQtXbFufL7NaZFmBf/rh4v/XXol2j+vOtmNlilAcczyzGROslBZM6SozhN5r5t9up1Ghzc5nFSPG78pnRwsFHi33lZZzwoIRATQiwMctBZl0rBUr4pN+LS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=qJGGTUFF; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="qJGGTUFF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n1plMMyIhqZm/1yY+TGu5dN1ZmuNrYf+7MNQAinowsc=; b=qJGGTUFFipHSWjsTvTm2mzx9XT
	Ak4DMmV8BrSHIfhr4Hcc79mcIFFAvOWcmQhJYPfIty6qQ1sH8lYHYNcAcva5NLc/taedBhpahyHce
	yO2dpI+V5BJV/11U6od6E0GGu2olLpX52DQNDbwkfxv44yfbDSKdL+zq4dVHgcaNp/TXKIdHufSg5
	kx5lP7yWNs6HIK9P3p/DzEyrqk7h082WgXCrvEK+6GUZ2MKwBmzJ1hjnyNvdawdvr0IDb7q9ClDLQ
	LemTi96PnhEXQDgW2b9E8NjqkV0gB5eM6ZqUDK5SBJBYHCxSZk9Yh2+LGV/pu6KJZCTiAUEq0wGdM
	zZW+KqvQ==;
Received: from [151.115.150.205] (port=44306 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxtSI-00000002nXQ-3dlV;
	Sat, 22 Aug 2026 23:40:45 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Sat, 22 Aug 2026 21:40:13 +0000
Message-ID: <20260822214012.1028305-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

find_prev_fhdr() returns the offset of the Next Header field before an IPv6
Fragment header through an int pointer, but stores the offset in a u8 local.
An extension header chain can put this field beyond byte 255, causing the
offset to wrap before it is saved in the fragment queue.

Reassembly later uses the wrapped value to update the preceding Next Header
field.  This overwrites another byte in the IPv6 header chain and can make
conntrack parse a different transport tuple from the one used by IPv6 local
delivery.  A two-fragment packet can, for example, be recorded as UDP
destination port 53 while its payload is delivered to UDP port 9999.

Use int for the working offset, matching the output argument and the other
offset variables in this path.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49bf0a0a..be72c4346f8b 100644
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
-- 
2.47.3

