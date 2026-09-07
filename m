Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A74E52123E;
	Mon,  7 Sep 2026 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801473; cv=none; b=k+AMUsHYHNW05fBcAqf7OXwb5PlGummGahg/ZNlTtD7CgGoAKrGl5+cOhX42Tdl0ZJUOtswf41bGCm2zaGuRU/TMc1+PVoR/WSyvQ0duG/At5F6+yB5w7IcPcvdv03uiMUfDlbX4yLQllHDSkzygbCkvMjiAUW//w7Kw5R9iWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801473; c=relaxed/simple;
	bh=PXTqS+GQgnrsiCZX+GNtxGZC4xHNLJGheaGb96Ayw7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuwK8m2BgD2HbjhIZvJzLUCmlb1XBiliC5HkhmcfPGGAKlLWHOEqzO5U4rAkzzr6MgzcV/JxuUqzzMAPt+NH84bQdczxjPuCnXc0lsFg+v0iG/G3UntXFdgeJeeWJgPlWr/+258NF+wAL22NJE6iVVylQIX04sdUszbHWdMLlsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=maTz2pCb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="maTz2pCb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801468;
	bh=YUFngmUn81a47yGKV484zk4utMtmk2YP5nnPEf+H5Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maTz2pCbq1Ym2BzlMvD2nJg/qeBcEuCZ1I4yJrO8LWZjGuK5Ylrv0YfzlI86Q3ivH
	 2MUs1zBUaOXJlENUie2H9lpGxvK2S0oqDUA+X6zedPvOOueLBXd79GzNMNKNTmQll+
	 VUJmUsSL6Cz7xhLRrXX9ACvZDaf3itn4iih6deVruTh5+TmmYWa3EXobE4uzX38zP7
	 AAQg8KAI1ohTaCk19Pmbim9oiSwrc8s0YhKBcKyzUmYcjl+MUzE750DC935Xg5mLxn
	 gGipRRJA76QIe6ziVsxwfYtlsdDS5XamD6ZUuuLzoapkBUULAJY4w1Ekabd7PFYc00
	 xZ+YtF3c+N+/w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6836D607D0;
	Mon,  7 Sep 2026 19:17:48 +0200 (CEST)
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
Subject: [PATCH net 8/9] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
Date: Mon,  7 Sep 2026 19:17:31 +0200
Message-ID: <20260907171732.1407739-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The ip6tables traverser doesn't search the extension header chain unless
userspace did set the IP6T_F_PROTO flag.

This also means that userspace that sets the e->ipv6.proto flag can bypass
the protocol check for the rule by not setting this flag.

That in turn means that all ip6_tables modules and targets that want to
reject rules without '-p' flag MUST also check for that flag.

Not all do, likely because they got copied from iptables which lacks
this flag (no extension headers).

Instead of fixing up all the relevant targets, emulate ip6tables behaviour
in the kernel (like nft_compat.c) and set the flag if the protocol is set.

Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6_tables.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f42fb96ef64b..313c4aac377a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -647,6 +647,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
+
+	/* set F_PROTO, else ip6_packet_match won't do the right thing. */
+	if (e->ipv6.proto)
+		e->ipv6.flags |= IP6T_F_PROTO;
+
 	return 0;
 }
 
-- 
2.47.3

