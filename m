Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1482949E0
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 22:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752965; cv=none; b=l0zDBbVJzI6DjAMz1mSXiIWf153G3ghRCos8xVefC4H1Y4lcq4sB8S2657jkuSMXkQjHerJ5J+fAcSMxrIuQZ/+HEk7A81d2vOIafANk9kg0nsXLW6s92c2TQGxZ0Xy67rAHDqvEmxo7hYTlNbbwyZZd7wEvJ67cX0knD/Ts3mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752965; c=relaxed/simple;
	bh=wFGlmTBVvf1sKSSCVf0NyySnq/wuwN9FFUIkc9+eNCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/fBUtZwJprv5bqxrwpjRGj9/AjxaOXylGmWvmFUznbuPfMwyu36snmAvmsF1GXW1VxRIy9GnIlGdAk0paw7O/wJIAzoOB8dhSGdiwie+K2i8CMU1b1DPUrWcbsAJTM62ZR2badvj1Ot2ZEZWERWIQDw+MXkPpE67KPzaPmH6Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DYfQM4Rj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DYfQM4Rj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DYfQM4Rj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DYfQM4Rj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A12B96024E; Thu, 25 Sep 2025 00:29:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758752960;
	bh=G/ome4bYMGBgmq/WBxOsX2C85qBr9AEh9TGZYG7ots4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYfQM4RjIqVBAcTC6Q7lnlktty7uHNkDEYyZbjnco7utp447B/Cpk8EoAhq7We6z6
	 XZ4rGswY/SjXtGjlKWXyHfCBL26YwYfSEzsH7DMriZXTecrSg9uQHy/Bi4Y43yV5/8
	 TLh+Vse+d/wJ2aZWqLA9RL8z2zQfoOp4z/KFK2AHdapnp0gmnGSxFSlDvrfcF5OwgW
	 WbdF5wlG6D03wBFGYyfFbz2lPuB65kgHq7N/eDc6anLno+5shp/MjcTbXsQTOgvPJJ
	 OsKrhKIQANayQmAXGh1q7IH/j1gHn7XEi1yfu4x0UVIDeo3/8NSOCrNnrSNrvqiRer
	 N4jKflqt52tJg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D86C46024E;
	Thu, 25 Sep 2025 00:29:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758752960;
	bh=G/ome4bYMGBgmq/WBxOsX2C85qBr9AEh9TGZYG7ots4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYfQM4RjIqVBAcTC6Q7lnlktty7uHNkDEYyZbjnco7utp447B/Cpk8EoAhq7We6z6
	 XZ4rGswY/SjXtGjlKWXyHfCBL26YwYfSEzsH7DMriZXTecrSg9uQHy/Bi4Y43yV5/8
	 TLh+Vse+d/wJ2aZWqLA9RL8z2zQfoOp4z/KFK2AHdapnp0gmnGSxFSlDvrfcF5OwgW
	 WbdF5wlG6D03wBFGYyfFbz2lPuB65kgHq7N/eDc6anLno+5shp/MjcTbXsQTOgvPJJ
	 OsKrhKIQANayQmAXGh1q7IH/j1gHn7XEi1yfu4x0UVIDeo3/8NSOCrNnrSNrvqiRer
	 N4jKflqt52tJg==
Date: Thu, 25 Sep 2025 00:29:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] netfilter: fixes for net-next
Message-ID: <aNRwvW4KV1Wmly0y@calendula>
References: <20250924140654.10210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>

Trimming Cc:

On Wed, Sep 24, 2025 at 04:06:48PM +0200, Florian Westphal wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for *net-next*:
> 
> These fixes target next because the bug is either not severe or has
> existed for so long that there is no reason to cram them in at the last
> minute.
> 
> 1) Fix IPVS ftp unregistering during netns cleanup, broken since netns
>    support was introduced in 2011 in the 2.6.39 kernel.
>    From Slavin Liu.
> 2) nfnetlink must reset the 'nlh' pointer back to the original
>    address when a batch is replayed, else we emit bogus ACK messages
>    and conceal real errno from userspace.  From Fernando Fernandez Mancera.
>    This was broken since 6.10.

Side note: nftables userspace does not use this feature. This is used
by a tool that is not in the netfilter.org repositories, to my
knowledged.

> 3) Recent fix for nftables 'pipapo' set type was incomplete, it only
>    made things work for the AVX2 version of the algorithm.
> 
> 4) Testing revealed another problem with avx2 version that results in
>    out-of-bounds read access, this bug always existed since feature was
>    added in 5.7 kernel.  This also comes with a selftest update.
> 
> Last fix resolves a long-standing bug (since 4.9) in conntrack /proc
> interface:
> Decrease skip count when we reap an expired entry during dump.
> As-is we erronously elide one conntrack entry from dump for every expired
> entry seen.  From Eric Dumazet.
> 
> Please, pull these changes from:
> The following changes since commit dc1dea796b197aba2c3cae25bfef45f4b3ad46fe:
> 
>   tcp: Remove stale locking comment for TFO. (2025-09-23 18:21:36 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-09-24
> 
> for you to fetch changes up to c5ba345b2d358b07cc4f07253ba1ada73e77d586:
> 
>   netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack (2025-09-24 11:50:28 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request nf-next-25-09-24
> 
> ----------------------------------------------------------------
> Eric Dumazet (1):
>       netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack
> 
> Fernando Fernandez Mancera (1):
>       netfilter: nfnetlink: reset nlh pointer during batch replay
> 
> Florian Westphal (3):
>       netfilter: nft_set_pipapo: use 0 genmask for packetpath lookups
>       netfilter: nft_set_pipapo_avx2: fix skip of expired entries
>       selftests: netfilter: nft_concat_range.sh: add check for double-create bug
> 
> Slavin Liu (1):
>       ipvs: Defer ip_vs_ftp unregister during netns cleanup
> 
>  net/netfilter/ipvs/ip_vs_ftp.c                     |  4 +-
>  net/netfilter/nf_conntrack_standalone.c            |  3 ++
>  net/netfilter/nfnetlink.c                          |  2 +
>  net/netfilter/nft_set_pipapo.c                     |  9 ++--
>  net/netfilter/nft_set_pipapo_avx2.c                |  9 ++--
>  .../selftests/net/netfilter/nft_concat_range.sh    | 56 +++++++++++++++++++++-
>  6 files changed, 73 insertions(+), 10 deletions(-)
