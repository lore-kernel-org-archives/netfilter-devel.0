Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E8B19B5A3;
	Thu, 27 Nov 2025 12:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246841; cv=none; b=NZLWqPMZphMG8SI71ePjIb7iP+DIE9CuyAyg/2++GkldXRvTOqZ02HAp98dID9fKA4FY53eowsVTOTWZXG577vQWfOvPNT+AT3gPtjfh8RRzNSFbGQdmWjVbPtWcYikvOfmc57atRTld3kfCLe7vLmt1kHxm2uCHy4z/vqwIrx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246841; c=relaxed/simple;
	bh=fXGvEoLzS5npgYCvOqsch3/ClFp8juPbtZWWwUL5sKM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbW9+ZXcoJuoXbH1VoJFegtPgfRJ4UIQCU5GWRH1pAlfTDKm1YKh6cnI9oA4mA2YK2d1NuYoKWOXAjSWxBRHPK4UVuj11aT3ceHsjeCgTlM8ao7sCnQ6fzw0BazdUOB5qLhNoBE7pR9e0HIUsV8zA7sb3b+mLtOeNsIx72FjYgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dp8HaYJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dp8HaYJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4716FC4CEF8;
	Thu, 27 Nov 2025 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764246841;
	bh=fXGvEoLzS5npgYCvOqsch3/ClFp8juPbtZWWwUL5sKM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=dp8HaYJk42SlhzYHFywKl/6JVsAs5SL6CfuM+pscv+aSe4KkKPKFM8LVzrQXB02dR
	 nGwKB0d3qBIPbwuNDIHnG/L5FKJyqbW3l2+d0iELiuI676E7t/MzrMlaLEAL9t3lQB
	 XoIBp754zf4iDFdd1MYxk5UaZw9NIpNCd3zKCDi9JbyLJ6b1LfNLWVMBfNqYvEu2SO
	 ind9sBr5xlIpOszOpBkzI6IcoyocYXYbU3yl/ZNZNdb0DCl83vC3/qAwL4CTF5ozNr
	 BDOSUwV1iA8Jb8TDF34tTEWqRgybO4rK+fHPVE6Crz6/aC4RXiKmc5i4ydXilboWZf
	 ECmuRPJf/V6mA==
Subject: [PATCH nf-next RFC 1/3] xt_statistic: taking GRO/GSO into account for
 nth-match
From: Jesper Dangaard Brouer <hawk@kernel.org>
To: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com,
 mfleming@cloudflare.com, matt@readmodwrite.com
Date: Thu, 27 Nov 2025 13:33:55 +0100
Message-ID: <176424683595.194326.16910514346485415528.stgit@firesoul>
In-Reply-To: <176424680115.194326.6611149743733067162.stgit@firesoul>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The iptables statistic nth mode is documented to match one packet every nth
packets. When packets gets GRO/GSO aggregated before traversing the statistic
nth match, then they get accounted as a single packet.

This patch takes into account the number of packet frags a GRO/GSO packet
contains for the xt_statistic match.

Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
---
 net/netfilter/xt_statistic.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index b26c1dcfc27b..d352c171f24d 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -25,12 +25,37 @@ MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
 
+static int gso_pkt_cnt(const struct sk_buff *skb)
+{
+	int pkt_cnt = 1;
+
+	if (!skb_is_gso(skb))
+		return pkt_cnt;
+
+	/* GSO packets contain many smaller packets. This makes the probability
+	 * incorrect, when wanting the probability to be per packet based.
+	 */
+	if (skb_has_frag_list(skb)) {
+		struct sk_buff *iter;
+
+		skb_walk_frags(skb, iter)
+			pkt_cnt++;
+	} else {
+		pkt_cnt += skb_shinfo(skb)->nr_frags;
+	}
+
+	return pkt_cnt;
+}
+
 static bool
 statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_statistic_info *info = par->matchinfo;
+	struct xt_statistic_priv *priv = info->master;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
-	int nval, oval;
+	u32 nval, oval;
+	int pkt_cnt;
+	bool match;
 
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
@@ -38,11 +63,18 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
+		pkt_cnt = gso_pkt_cnt(skb);
 		do {
-			oval = atomic_read(&info->master->count);
-			nval = (oval == info->u.nth.every) ? 0 : oval + 1;
-		} while (atomic_cmpxchg(&info->master->count, oval, nval) != oval);
-		if (nval == 0)
+			match = false;
+			oval = atomic_read(&priv->count);
+			nval = oval + pkt_cnt;
+			if (nval > info->u.nth.every) {
+				match = true;
+				nval = nval - info->u.nth.every - 1;
+				nval = min(nval, info->u.nth.every);
+			}
+		} while (atomic_cmpxchg(&priv->count, oval, nval) != oval);
+		if (match)
 			ret = !ret;
 		break;
 	}


