Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D0C3D16E5;
	Sun, 27 Sep 2026 22:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546910; cv=none; b=oFZuW/oUcVm6AIXA7jLa3EV6hRmugmckt1d9Yl5N0WS1OUvI1tQ6Z4q4doTAzP3q6HmMbSsP/7IhUUgvsK6lFYqFWdTvprf39H+Fqt6iFYcggi8Dx7pmsVXug1sRrF5sMmfSJ+ASQuFE8o4cWUYFfYEn8GGI2nQwTsEDmydFiRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546910; c=relaxed/simple;
	bh=fzej0HmASZ9PENY4kx9y96NjfnMuddBusSPiGLkVajs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe4kjIBHLeluzXMyGcnnfoxkGDb7i0VPhbvLM6SfEtzR+ggWWblwTbyczsk2hW3EvWO+UQ5IwxHTysAJkOZGbZqjAUj67RA5Fzs3I3BFeCgCC7j4HO85IHwakegf0Kh2lOLm2HJrl0Vl+YLaGg6D3A2ArkALq8X7pBXDww8uZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cMn0uQ/m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cMn0uQ/m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546907;
	bh=KU+tVmN+MN6IdpYk3WtJkW77/a5ALSsNuPAh4TkuvjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMn0uQ/mYSfaZAT+Af1SMvv5SCmFl6UjFcDiMSvo2k0ZlOIUAEJ0MI7SIgdWkJ+At
	 wlQBrX2p/0tFS7cvFZAquRuIn0GeGeMRvqxrJq8wL3PKdZJCHwV4CZL9U5ru7k8H56
	 IKem2AYds/cfc+7f13TJ0Vg+EWBy8lrNMuom0rKIifwTLplEun7zBiuCao7qEnjv48
	 alvf7U3ts1Ud6k1OZllK+cBA+VtBmuARZt+dL+mQARsvX+oZvP3X/JtCT1eEvrOKTu
	 1Crq8B3tkikjKNDhqVzyo/3L1fTZU9Fp7XDEANB+pNQQjpw+mKrUokclyjfkWebsgB
	 1pbPvsqBnRXkA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A31D2603E0;
	Mon, 28 Sep 2026 00:08:26 +0200 (CEST)
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
Subject: [PATCH net 04/11] ipvs: fix missing counter decrement in lblc
Date: Mon, 28 Sep 2026 00:08:09 +0200
Message-ID: <20260927220816.268206-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
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

