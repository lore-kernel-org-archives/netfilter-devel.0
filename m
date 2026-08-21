Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B042B75A;
	Fri, 21 Aug 2026 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326756; cv=none; b=n2znJC9IT+w9FWiwRgROWm/KoVKo+g2Ru1JV9GOpX8t3crZkxVUql5Px+qRLjNHwimDiCFxur3P1HChZpib8WPitp89A+hwB6O84I5Ma8VtYQLQLXbrArDt2DHAWoIFWLWiV5TnWCYRdI51jFfeRcIfB/dzUd0bKA1Y485nf9I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326756; c=relaxed/simple;
	bh=D3kYz19dbJoHCMLTrlmJmUIRtdpCKnZ5WnOoTAS68qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE/eHPyo8pA/ASowHvsm8oqkIRat1MOBWzgiBoeFjw4vHyz3x51f6cuYqDoB1HKm2VsXjinnDGXMdSKnTW2x8jXj5+IwsLHDwNSq+iDols/4LCVFPDg6/kUGoOc59ONd8viSjC81U1RXGnRdOu6Kaps8dzxwK2t8nl6suu4gYiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VTO7Rw3+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VTO7Rw3+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326749;
	bh=NjoJ5AGJkle91/bS2voX13Lfg9On22etO4k9d0QaRkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTO7Rw3+KDXOYsnWQG2c+SYR4W97/fNxDIfSMk/PO6Sn3833U+58ZDkd4coT0fHy1
	 /LdJDIhnp5UJ1EU+3GVyQE8yl/rK+4oEU9a+vKYlt8KwDtNKmYunZtF4vTyKro4+Q0
	 czoL08NxFm1Wrn501u+x2eHZEb3HWwwock3AI37Aiu7SUnbQYQ7SFoO/j/Encf4Mda
	 /3mfRkQYJ17TkSSpxG1aHkU3gXhTBM8J57XgkUfH7AXNzTjZ6HXKlIcePCmxtZWKEg
	 YCVTElOEDCj2wR6s3VWtPl/RziG55qzPfBY3jgn4tf1JffGBACd6Gn/8Iho1kbC3NS
	 uvCoQesxd4KcQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4417B60094;
	Fri, 21 Aug 2026 17:39:09 +0200 (CEST)
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
Subject: [PATCH net 08/10] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Fri, 21 Aug 2026 17:38:31 +0200
Message-ID: <20260821153833.245589-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Currently, a netdev chain or flowtable hooked to a device prefix can be
unintentionally deleted or updated by a control-plane request targeting
an exact device name or even a shorter one due to the usage of min() to
calculate the length to match.

Fix this by making sure an exact device match never matches a prefix and
that both the target and the candidate have the same length.

Reported-by: Wei Fang <void0red@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20c562174b27..d160f6ea0dc2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
-static bool hook_is_prefix(struct nft_hook *hook)
+static bool hook_is_prefix(const struct nft_hook *hook)
 {
 	return strlen(hook->ifname) >= hook->ifnamelen;
 }
@@ -2445,8 +2445,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strncmp(hook->ifname, this->ifname,
-			     min(hook->ifnamelen, this->ifnamelen))) {
+		if (hook_is_prefix(hook) != hook_is_prefix(this))
+			continue;
+		if (hook->ifnamelen != this->ifnamelen)
+			continue;
+		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
 			if (hook->flags & NFT_HOOK_REMOVE)
 				continue;
 
-- 
2.47.3

