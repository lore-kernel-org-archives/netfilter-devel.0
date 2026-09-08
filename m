Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262EE3B6BF2;
	Tue,  8 Sep 2026 20:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899727; cv=none; b=obxohVIQeQFOgRDMTOh2NrARNrVldt3ksFpNala2vi5P4WtAI7fXlC3ddBxEa/ounbjgtMkTLD5LLRtHaALoC7eVqxSNa4M8s2VoCT9i1SrAWAXvymSutWWA1UqFfvcH0QvQttEyhUVZNRn6AHLW+Etx4WTvHrXK2p+T5SCKYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899727; c=relaxed/simple;
	bh=OnYeN0vTrQH/ecU6wkRw9nAkQwdTsrDOJIN9ZUUUOQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ooknb+2BwJlV6UoPQSVPTWakSE2q/d+Ka3SNxsV4s+V0z9Lg9dznbLTcpEuTR8FJy2cnshC/pogfgvElfMRG1JjeCW9kfesBaeb9h7n1OKOnEycVA3QAfR6qyL5HRZbfXarGJeIRpKp65JL01+Z0b9pO13uB/9riCE+RSR3YdFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bbZhIv7l; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bbZhIv7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788899722;
	bh=b7hThC8HVJ+JVYh8MfDmTJ4I3tJmm1vPI+vOThTdjBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbZhIv7lt/vqCQ7jiyDO+AzacdcKpAxLNdGVRag4o0pcn28mLlJE3nf21PpBusBti
	 WV2JtI1M4atPuPKh/kFA5siSE+YfjBdRBGIqwCSrPiNnoXWMtmsF8flpsbV0KSNLJv
	 JvEoNMXNk6d3PpaSdNcRwJ/G3pS57IO2wRX4VOrOxBqHukkBsEYA8mYY5DDlQrLGC7
	 1AH9NWPV6nFrlxLauXGPeyv/5320Xq2tNklSaUS6KXqJ2rQ8qbQEK+PpZ2dPkzccui
	 +YbbmL8glmvQDt3Y09T01UqEf4vZDQeTop9OFgV5SaPyQ7q6QMtD5yXO4hp8FeI2+y
	 iwyB5J+kpm0Xg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6206E6075C;
	Tue,  8 Sep 2026 22:35:22 +0200 (CEST)
Date: Tue, 8 Sep 2026 22:35:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 8/9] netfilter: ip6_tables: set F_PROTO when proto
 value is nonzero
Message-ID: <aqBxiIKXKkffxaGy@chamomile>
References: <20260907171732.1407739-9-pablo@netfilter.org>
 <178889064403.219967.3259522251975828189@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178889064403.219967.3259522251975828189@kernel.org>

On Tue, Sep 08, 2026 at 06:04:04PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 0 · Low: 1
> 
> - [Low] Stale/contradicted UAPI documentation for `struct
>   ip6t_ip6::proto`.
> 
> --
> 
> netfilter: ip6_tables: set F_PROTO when proto value is nonzero
> 
> This makes the kernel set IP6T_F_PROTO for any rule that carries a nonzero
> ipv6.proto, so ip6_packet_match() always performs the protocol comparison
> and extension header walk instead of skipping it when userspace left the
> flag clear. It mirrors the normalisation already done in nft_compat.c.
> 
> > diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> > index f42fb96ef64b6..313c4aac377aa 100644
> > --- a/net/ipv6/netfilter/ip6_tables.c
> > +++ b/net/ipv6/netfilter/ip6_tables.c
> > @@ -647,6 +647,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
> >  	/* Clear counters and comefrom */
> >  	e->counters = ((struct xt_counters) { 0, 0 });
> >  	e->comefrom = 0;
> > +
> > +	/* set F_PROTO, else ip6_packet_match won't do the right thing. */
> > +	if (e->ipv6.proto)
> > +		e->ipv6.flags |= IP6T_F_PROTO;
> > +
> >  	return 0;
> >  }
> 
> [Severity: Low]
> Should the uapi header comment be updated in the same patch?  The
> description of struct ip6t_ip6::proto in
> include/uapi/linux/netfilter_ipv6/ip6_tables.h still documents the
> opposite contract:
> 
> 	/* Upper protocol number
> 	 * ...
> 	 * - You also need to set IP6T_FLAGS_PROTO to "flags" to check protocol.
> 	 */

That is still the indeed recommended practise, so no, comment must be
not updated.

This is just makes a work-around for broken userspace code that has no
real usecase other than triggering a bug.

Quite a bit of noise from LLM, one pre-existing issue found, but other
than that, just lengthy text noise.
