Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F3E411F80;
	Wed, 30 Sep 2026 07:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754120; cv=none; b=spWjPHrHuISvsyAx4SeorjmHMTTOtG7PE0j1qTWVmDAthCjzQObFdu/wkXZdTRgwCGNkdILXdp64Id6azz06VuiYLw9WGSEQ47y/UdTzIJ9wklvqHeZVxloelrm3LKzZf7bpvhgQpFHN10i1thJXGv6NDVo7PwFOnv1WMZS70sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754120; c=relaxed/simple;
	bh=fzej0HmASZ9PENY4kx9y96NjfnMuddBusSPiGLkVajs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKfxw34hi/W8RkG93QiLmt3fi+XEuObZ/TLHF+DKrq/VDZryOHsPT5Ana42nLIIASuBkRd2v9SsqxgDjtFFoU1aEHIlv/ENKLKUK27Dbyaa6Xj8zLj0XsQRIbHAXrNfetKBK7NbNWXjPMEm/xVCSbXfnBan8pvSGBRK0RDRhMv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KzLeXLXx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KzLeXLXx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790754111;
	bh=KU+tVmN+MN6IdpYk3WtJkW77/a5ALSsNuPAh4TkuvjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzLeXLXxikaI97qgOSDUxKPZX/Y2qdKDm57CrSbujbdqCw9psYzIbeGEq6Lb9QyX7
	 1+GHR6DRpQkH1MCqncig1MCbFYLX3ETJqZHS4lQOJ9WSfMBgcEXsdP1tG3nTk1CQgW
	 RnROIBJvG6Vcxk2xGYwOqchtk3yXAVGNcY3J9lSP7ic03UtrsYL0+EvH/fON8XqgoZ
	 CT5aub/HLBFiQ7jymKmXDM6qV1qrLOeLJeNqcgvpXusTr7pUU55DpuWwAdBVHYsirG
	 Nz5PMAK5SF+PXpiaJ7cSy2luli0CLaUn/yJhsU+gXXju7c1L01cE4NrA8LLmyY2AEl
	 LpUga89qU4bUQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9CD146068B;
	Wed, 30 Sep 2026 09:41:50 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 03/10] ipvs: fix missing counter decrement in lblc
Date: Wed, 30 Sep 2026 09:41:34 +0200
Message-ID: <20260930074142.298353-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930074142.298353-1-pablo@netfilter.org>
References: <20260930074142.298353-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

LBLC may delete cache entries for destinations that are
removed or overloaded and replace them with available ones.
But ip_vs_lblc_new() forgets to decrement the tbl->entries
counter after calling ip_vs_lblc_del(). This can lead to
increased shrinking of the cache with every new garbage
collection.

Fixes: 2f3d771a35fe ("ipvs: do not use dest after ip_vs_dest_put in LBLC")
Link: https://sashiko.dev/#/patchset/0bdd5abe9968ded7ca2b9cb6844ba83d94cc8d53.1787318053.git.zhilinz%40nebusec.ai
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 693bcc82ccb7..a2b574904f13 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -203,6 +203,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	en = kmalloc_obj(*en, GFP_ATOMIC);
 	if (!en)
-- 
2.47.3

