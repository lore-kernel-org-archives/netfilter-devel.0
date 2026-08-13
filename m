Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30547255A
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 12:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786622432; cv=none; b=eCG9zRpsugk9TXL/GpKwvBMmOlTB9rdo4lZNqodesk31Cs198nFtwfT6Dni4fNgA0ycX1bAFWYAsZ8YFN/tsPOL6zE4yETu8kci1LxZA/RrSFMozYJZfEgf1iey62czDNKtESCrDnmCj80PUR2TzjAnXmd7xPDPnLWw8JOLWJfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786622432; c=relaxed/simple;
	bh=UG7yUo4hGpvRObwENe1hGmPCzpMjUMvvpZmBZu4ruNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+wYKg3FTjdUxLbPt8JlkSDiWaWeQA76t8D/qL4GcxW+htnICRZHSbO3wZsaPbB7pPN7MbLMiM24obizb6f1Wm8tD6FaIsDZY7z+NElnkpsDi8Pxd2clAFypmOjIwGsnrlHZDopcxRRN8/iG7wHrjdrbImuJPlCc/R1+82lfNKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LZ86Xjs8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LZ86Xjs8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786622426;
	bh=6gQ2Lx2mHUDCrwVddybJi++7VGHnsnaTl5Sh7jFwdTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZ86Xjs8sHDE41oMxSgMLD3cU52bZWsYU7ozEKwhQ4Aq158YgCWlEwaAtPgyrAg5b
	 tTIUvdBlzd2cMhiRyeBL6+q3bKXsPOy9AirN08MZ3QTKy9GCq13OEE/eZ85TfGAAmO
	 tfywxxjzT0RqFt5X4wop9KYMxfZ5qqT8NhyWdUKEmDqqLg7tyNlxybJhdmn4vhWSY8
	 Aq3EoaJD5DOWpUp0zH5F0h41AFkr7YdGZqwmJwRcgoKZM8XJ5EU82NMU7eE1TvTfga
	 EFyFSH/xUo9LCUarjMsgvaCK0no51fgzJhf/ZrV3U5i76nwvGBGXI5ZU7uB4pbmOyr
	 awrOzO4yG9uiQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E37776005B;
	Thu, 13 Aug 2026 14:00:25 +0200 (CEST)
Date: Thu, 13 Aug 2026 14:00:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: Re: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol
 values
Message-ID: <an2x1tOQN99iCI8L@chamomile>
References: <20260813114556.2685869-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260813114556.2685869-1-phil@nwl.cc>

Hi Phil,

On Thu, Aug 13, 2026 at 01:45:54PM +0200, Phil Sutter wrote:
> Adjust the test wrapper to create dumps with --numeric-protocol option
> (patch 1) and update all dumps (patch 2).

Is this to make it consistent through different distros due to
different definitions in /etc/services?

Thanks!

> One could also set --stateless, py test suite does that, too. Though
> there are tests (in packetpath dir) which seem to rely upon counter or
> other stateful data to be matched in dump files, so keep state for now.
> 
> Phil Sutter (2):
>   tests: shell: Use --numeric-protocol for dumps
>   tests: shell: Convert dumps to numeric protocols
> 
>  tests/shell/helpers/test-wrapper.sh           |  9 ++--
>  .../cache/dumps/0003_cache_update_0.json-nft  |  4 +-
>  .../cache/dumps/0003_cache_update_0.nft       |  4 +-
>  .../chains/dumps/0041chain_binding_0.nft      |  4 +-
>  .../maps/dumps/0010concat_map_0.json-nft      |  2 +-
>  .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
>  .../testcases/maps/dumps/0013map_0.json-nft   |  2 +-
>  .../shell/testcases/maps/dumps/0013map_0.nft  |  2 +-
>  .../maps/dumps/anon_objmap_concat.json-nft    |  4 +-
>  .../maps/dumps/anon_objmap_concat.nft         |  2 +-
>  .../maps/dumps/named_limits.json-nft          | 14 ++---
>  .../testcases/maps/dumps/named_limits.nft     | 14 ++---
>  .../maps/dumps/nat_addr_port.json-nft         | 16 +++---
>  .../testcases/maps/dumps/nat_addr_port.nft    | 16 +++---
>  .../maps/dumps/typeof_maps_0.json-nft         |  6 +--
>  .../testcases/maps/dumps/typeof_maps_0.nft    |  4 +-
>  .../dumps/typeof_maps_add_delete.json-nft     |  2 +-
>  .../maps/dumps/typeof_maps_add_delete.nft     |  2 +-
>  .../dumps/0012different_defines_0.json-nft    |  4 +-
>  .../nft-f/dumps/0012different_defines_0.nft   |  2 +-
>  .../dumps/named_set_as_protocol_dep.json-nft  |  4 +-
>  .../nft-f/dumps/named_set_as_protocol_dep.nft |  2 +-
>  .../testcases/nft-f/dumps/sample-ruleset.nft  |  4 +-
>  .../optimizations/dumps/merge_reject.json-nft | 12 ++---
>  .../optimizations/dumps/merge_reject.nft      |  4 +-
>  .../dumps/merge_stmts_concat.json-nft         |  4 +-
>  .../dumps/merge_stmts_concat.nft              |  2 +-
>  .../dumps/merge_vmap_raw.json-nft             | 10 ++--
>  .../optimizations/dumps/merge_vmap_raw.nft    | 10 ++--
>  .../optimizations/dumps/merge_vmaps.json-nft  |  4 +-
>  .../optimizations/dumps/merge_vmaps.nft       |  2 +-
>  .../dumps/exclusive_start_cond.json-nft       | 52 +++++++++----------
>  .../parsing/dumps/exclusive_start_cond.nft    | 42 +++++++--------
>  .../parsing/dumps/large_rule_pipe.json-nft    | 24 ++++-----
>  .../parsing/dumps/large_rule_pipe.nft         | 12 ++---
>  .../0037_set_with_inet_service_0.json-nft     | 10 ++--
>  .../dumps/0037_set_with_inet_service_0.nft    | 10 ++--
>  .../shell/testcases/sets/dumps/0047nat_0.nft  |  2 +-
>  .../sets/dumps/0067nat_concat_interval_0.nft  |  6 +--
>  .../sets/dumps/0067nat_interval_0.nft         |  2 +-
>  .../testcases/sets/dumps/set_eval_0.json-nft  |  4 +-
>  .../shell/testcases/sets/dumps/set_eval_0.nft |  2 +-
>  .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
>  .../sets/dumps/sets_with_ifnames.nft          |  4 +-
>  .../transactions/dumps/0049huge_0.json-nft    | 16 +++---
>  .../transactions/dumps/0049huge_0.nft         |  8 +--
>  46 files changed, 186 insertions(+), 185 deletions(-)
> 
> -- 
> 2.54.0
> 
