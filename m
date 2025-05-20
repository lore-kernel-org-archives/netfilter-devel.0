Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFA0270545
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739021; cv=none; b=tiQy0/gDTO+h5XIGRvf7aaCGQFF1Zx/Zn152v1Iykn94g75svRfT3E83kScNwT8ivf4SSJ42erEoQzGHBEx4n0JJTb1gd9wboBU7SGP8bahELpYTyV+KccUTRROGAgfdQxHPf0xwanRHUEIQzDU45adYGA9zNVu90B9rBHUtkiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739021; c=relaxed/simple;
	bh=co9zrALrp38t1qcXr5nDnBaRWG+YijiSiWx1TR1BGN0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaRQCgWA5rJ5wPk7aY+aQe/SVghf4KI2kSFD7SVd+1UAjrq6j58EHUcRTst54o7YZ17FDaxvD4etp/W2k4zz0teLKlfbbNBpN0siJROD59dsgsuxy7E0nuj7aRilUvBDvJbGq7d9IekHoY3he+ZbeLE84+IrAt4Oea0InK4wQ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VkcZhvCr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sDcSl75F; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VkcZhvCr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sDcSl75F"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D29FB60695; Tue, 20 May 2025 13:03:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747739016;
	bh=HXBk3wGk793BKIGBeHX2PfvBQ43o9lNAGfghlf3NN40=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VkcZhvCr7A6GMKJoWjGKbu58vwigx0EYRK+Tx/7vn0a9Kb7N4pNZKBUXNxQaHlyxV
	 zHkURKOuLobIsEPxGVg9XGrtXALQ1PGjc1BvvgwgSAYbdTFfqZAE9d/rFHvqB4meZ4
	 h5OmIEW6IPhDZFG3SYD38tjYIp4kOmMmBSoy2ht9CUwYX50Wk3aB/AjvomFLzSQDBc
	 dEIDo7LUftI3KM28J54yE1mefJ0u34nI6UeYZkpsSvEBE1TLhZK1iTtkYbOkbzOoh8
	 hOeUWGXnBKZaHZZqqJZZ1qLT390vYMj/6nfcvTcU1tf3zllqomngKcwikK4sJKjjOp
	 poNoCOSRih3yA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6272F60572;
	Tue, 20 May 2025 13:03:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747739015;
	bh=HXBk3wGk793BKIGBeHX2PfvBQ43o9lNAGfghlf3NN40=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=sDcSl75FUgig6gXVuA+cHCCqaondQau9uFB+WAp4hpzl1y8lc4GI65U2L49YPdLKU
	 hDBJX0LI56MA8PCP6TxErovk2yOLDFMqz3LXKb4Fo2rBw/sLZw0hU8EYoxNcxiH3kI
	 so5WQzEvs9NiHDv/R5kMGCNUPHxPMg+NlZGqz9qUmKgbkVOhIUMjBZ+lZdONOhmo3e
	 HPo0GOhN8URcwDTQT0iIf9BARSX1L164Y+EX7BeTMeCtSsPR/J5TmNPAQeLXaaLVIu
	 7iQEBxwh8m/CeC3b6SQzcCLO+hMKsZJiDH9sdKZfvXCjQgCBMrW5tFlrLCtHfw4dLD
	 s8ItiiXJ+1SVA==
Date: Tue, 20 May 2025 13:03:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aCxhhBWNsVQYluX5@calendula>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aCxgYJAE5G7nMi7V@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aCxgYJAE5G7nMi7V@orbyte.nwl.cc>

On Tue, May 20, 2025 at 12:58:40PM +0200, Phil Sutter wrote:
> Bump!
> 
> Anything I can do to help push this forward? The series I submitted to
> add support for this to libnftnl and nftables should still apply as-is.
> Anything else missing on my end? Or should I try to break this down into
> smaller patches/chunks?

I was exactly now looking into integrating this into nf-next, sorry
for the slow turn around.

> Thanks, Phil
> 
> On Tue, Apr 15, 2025 at 05:44:28PM +0200, Phil Sutter wrote:
> > Changes since v5:
> > - First part split into separate series (applied and present in Linus'
> >   git already).
> > - Add nft_hook_find_ops_rcu() in patch 2 already to reduce size of patch
> >   5.
> > - New patch 4 to reduce size of patch 5.
> > - New patch 6 preparing for patch 7 which in turn combines identical
> >   changes to both flowtables and netdev chains.
> > 
> > Patches 1-5 prepare for and implement nf_hook_ops lists in nft_hook
> > objects. This is crucial for wildcard interface specs and convenient
> > with dynamic netdev hook registration upon NETDEV_REGISTER events.
> > 
> > Patches 6-9 leverage the new infrastructure to correctly handle
> > NETDEV_REGISTER and NETDEV_CHANGENAME events.
> > 
> > Patch 10 prepares the code for non-NUL-terminated interface names passed
> > by user space which resemble prefixes to match on. As a side-effect,
> > hook allocation code becomes tolerant to non-matching interface specs.
> > 
> > The final two patches implement netlink notifications for netdev
> > add/remove events and add a kselftest.
> > 
> > Phil Sutter (12):
> >   netfilter: nf_tables: Introduce functions freeing nft_hook objects
> >   netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
> >   netfilter: nf_tables: Introduce nft_register_flowtable_ops()
> >   netfilter: nf_tables: Pass nf_hook_ops to
> >     nft_unregister_flowtable_hook()
> >   netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
> >   netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
> >   netfilter: nf_tables: Respect NETDEV_REGISTER events
> >   netfilter: nf_tables: Wrap netdev notifiers
> >   netfilter: nf_tables: Handle NETDEV_CHANGENAME events
> >   netfilter: nf_tables: Support wildcard netdev hook specs
> >   netfilter: nf_tables: Add notications for hook changes
> >   selftests: netfilter: Torture nftables netdev hooks
> > 
> >  include/linux/netfilter.h                     |   3 +
> >  include/net/netfilter/nf_tables.h             |  12 +-
> >  include/uapi/linux/netfilter/nf_tables.h      |  10 +
> >  net/netfilter/nf_tables_api.c                 | 394 ++++++++++++++----
> >  net/netfilter/nf_tables_offload.c             |  51 ++-
> >  net/netfilter/nft_chain_filter.c              |  95 ++++-
> >  net/netfilter/nft_flow_offload.c              |   2 +-
> >  .../testing/selftests/net/netfilter/Makefile  |   1 +
> >  .../net/netfilter/nft_interface_stress.sh     | 151 +++++++
> >  9 files changed, 587 insertions(+), 132 deletions(-)
> >  create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh
> > 
> > -- 
> > 2.49.0
> > 
> > 
> > 
