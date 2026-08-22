Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B809D33260B
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Aug 2026 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787386463; cv=none; b=qvg38S3hJ4CYwu4FuBvhpzFX+ZpemNmKWk3Uq5LEACM9786WK2ZWVA7dU6Msm6EPZsGpBug7e/Of8gKkQWpqDdUVcUuA1KOS8WHo+c/QGw5ddyU/tz4AVxuDRjShI7lu6QRulr8XbYUEcyp3M3PeMxzKt2qVRiOB6ZaK7tYxfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787386463; c=relaxed/simple;
	bh=x9QYQUykGRJVsCLttahJWpPKup9Jt0yWXvXGFh86Vco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVlm3uYZ6bka/H1I6OwiVeY4EldNNczAaqf5O4MjCWaGTH81PG6NgqqXOn7fbdqY3ZBekpGYpdUcZQQFU0W4Xpiu93TZ1DyozKBbyhrz5UKB9Awo+XyWSx6PYEkuvxvPtJYEasAY8mKg5gZ4uS18s8PhLl8q5VqpIqFQ/LcQlog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 60E9B6051B; Sat, 22 Aug 2026 10:14:19 +0200 (CEST)
Date: Sat, 22 Aug 2026 10:14:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aolaWzC1PI7zeYRN@strlen.de>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aohabszy_Ac23p7x@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Aug 21, 2026 at 03:41:36PM +0200, Florian Westphal wrote:
> > ip6tables traverser doesn't walk ipv6 extension headers unless the PROTO
> > flag is set, so direct sockopt-users can bypass the check (ip6tables
> > always sets it if '-p' flag is given.  This is a cleanup patch, it
> > doesn't fix any real bug.
> 
> I really think it is better to squash the TPROXY fix into this one
> too, it is the same logical fix.

I don't mind either way.  I did not do it because unlike TPROXY these
are benign.

> Sashiko also hinting to fix ip6_tables core check for this protocol
> flag:
> 
> https://sashiko.dev/#/patchset/20260821134136.18191-1-fw%40strlen.de

Not so sure.  Maybe just do this?  I don't think proto > 0 and flag
unset makes any sense.

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -647,6 +647,13 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
+
+	/* Make sure F_PROTO is set, else ip6_packet_match
+	 * won't do the right thing.
+	 */
+	if (e->ipv6.proto)
+		e->ipv6.flags |= IP6T_F_PROTO;
+
 	return 0;
 }
 
