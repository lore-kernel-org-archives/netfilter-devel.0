Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0543421CC40
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747738725; cv=none; b=DRiBnuRL1JbM/ZZrcOtBBwPlhplrTeUiBSQdKLVjM546SsTGGNz1kACh1Bzi3pB5xrxIRKe511RL+Tp3ZQ+Q9iaVTINeRG9W92q49f4Tbm+WQLSuelwPMp0YehRh4SVbS/+VSbUo6MWZLSZivtGn9clctvJWv03aEqTJMYjK86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747738725; c=relaxed/simple;
	bh=nJUNMT7iztMpapB5q8vsZ8EhQB+fB3XUML/UWbvbOvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LXcu+UI8/0TrsThEovGS5UDBJW8YyYybCojVhT0IjFmDfDQiuwV6XSrdC/WJE5oF+YTgOV8/dP3TPJCFFvAv5DEhcfY/2pXbv+c9jOuvuUSymMZcYih+uuOcxKcamsdEn+ELpJaYmKj21QfBif+msOeOBLOd8kKCD5WY4cqYGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HBCKf7ZK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HBCKf7ZK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m9WkG77jM+Z6EbZTlGHFHkewNU1xJvBEKQvAFfRB/Hk=; b=HBCKf7ZKXHm8PdNcCtVwl61/Km
	Q14NlscNHN11d7y/gDMhx9/LBMZ0ruK2shPwmaQryoGWQa/HmbDjURwbqLNzqztzkP5j/jgAf0DTY
	o4+PFpuJ/74Imz0E7UfDURyfhAJpSih6YRRfNJaKeH69ug4wVIF10E8sm0QOZMreBvvEgDR4TE6Ei
	nEhetwh+AWalPMgyG5ZqK6Y2LypTKZr/v+wpknWfLcTKzALPbaSkcH/wXBAugSojIog6QnmSTZjYA
	6trkSS28rA46TqpRaVYXYZaagQCXRHE5ocJ0vbV/p0XuPA4d0P1UO6RNPSBsxRwLXtpZ3RD0Ruimr
	V60UG/sw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHKgC-000000008Mo-2Rhc;
	Tue, 20 May 2025 12:58:40 +0200
Date: Tue, 20 May 2025 12:58:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aCxgYJAE5G7nMi7V@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>

Bump!

Anything I can do to help push this forward? The series I submitted to
add support for this to libnftnl and nftables should still apply as-is.
Anything else missing on my end? Or should I try to break this down into
smaller patches/chunks?

Thanks, Phil

On Tue, Apr 15, 2025 at 05:44:28PM +0200, Phil Sutter wrote:
> Changes since v5:
> - First part split into separate series (applied and present in Linus'
>   git already).
> - Add nft_hook_find_ops_rcu() in patch 2 already to reduce size of patch
>   5.
> - New patch 4 to reduce size of patch 5.
> - New patch 6 preparing for patch 7 which in turn combines identical
>   changes to both flowtables and netdev chains.
> 
> Patches 1-5 prepare for and implement nf_hook_ops lists in nft_hook
> objects. This is crucial for wildcard interface specs and convenient
> with dynamic netdev hook registration upon NETDEV_REGISTER events.
> 
> Patches 6-9 leverage the new infrastructure to correctly handle
> NETDEV_REGISTER and NETDEV_CHANGENAME events.
> 
> Patch 10 prepares the code for non-NUL-terminated interface names passed
> by user space which resemble prefixes to match on. As a side-effect,
> hook allocation code becomes tolerant to non-matching interface specs.
> 
> The final two patches implement netlink notifications for netdev
> add/remove events and add a kselftest.
> 
> Phil Sutter (12):
>   netfilter: nf_tables: Introduce functions freeing nft_hook objects
>   netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
>   netfilter: nf_tables: Introduce nft_register_flowtable_ops()
>   netfilter: nf_tables: Pass nf_hook_ops to
>     nft_unregister_flowtable_hook()
>   netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
>   netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
>   netfilter: nf_tables: Respect NETDEV_REGISTER events
>   netfilter: nf_tables: Wrap netdev notifiers
>   netfilter: nf_tables: Handle NETDEV_CHANGENAME events
>   netfilter: nf_tables: Support wildcard netdev hook specs
>   netfilter: nf_tables: Add notications for hook changes
>   selftests: netfilter: Torture nftables netdev hooks
> 
>  include/linux/netfilter.h                     |   3 +
>  include/net/netfilter/nf_tables.h             |  12 +-
>  include/uapi/linux/netfilter/nf_tables.h      |  10 +
>  net/netfilter/nf_tables_api.c                 | 394 ++++++++++++++----
>  net/netfilter/nf_tables_offload.c             |  51 ++-
>  net/netfilter/nft_chain_filter.c              |  95 ++++-
>  net/netfilter/nft_flow_offload.c              |   2 +-
>  .../testing/selftests/net/netfilter/Makefile  |   1 +
>  .../net/netfilter/nft_interface_stress.sh     | 151 +++++++
>  9 files changed, 587 insertions(+), 132 deletions(-)
>  create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh
> 
> -- 
> 2.49.0
> 
> 
> 
