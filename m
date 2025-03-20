Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9FDEEBA
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742479535; cv=none; b=Us9bkj1eRtdKyumpiQVelwHQlyABALlmo5xtp/uWi2sXglH4TLPMBaXaP4ENqPj6M9bD25DFL/UEOKltTvkDTU6EcySD9vGxgGdEdl4v94WmKkafv5YoadbZAjWlqVWeXMi2SmA2I/HIwwJoDqjqHcODmkidRpgkvVHDdzuCf80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742479535; c=relaxed/simple;
	bh=tcAwFG+q+K+2wNoRJQnUG0JuwgJPe+16bg3eRu53SLU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAyIVQ94UijxYq7N3KD0zAyQuDy3NUq+XerKAGN3hJ80Ji8vTAsIhxSfE8lpYDqmQe+iyVl9nES1bjvKTd9oHBsBri/5U3x/lh2BfuxVI6vVbtMywZ9bZqINYJZqK0x5tDLbcqj819mBU0ZdbfEp6W0WcBUygOcULsAwtHQ/KVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RzvrVd7q; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RzvrVd7q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I0ZdXsKzrG2xSSqq54XJgsQOdpNsyjVAddKzMsZJNSU=; b=RzvrVd7qtE30ZoWyceYTdLJ0iH
	rUXbwLpr0qzkfNXpTAhYFDPbo1B/pwE3PBfSg0tgxlD30aneMU0wQLYFmCyvMHZShxxvLKC3UbwHU
	5/ceIfr0E4znr00R30p9eOTvaZ5HpQoZ6DamoiWuTvKeLYFg/5SgPs9llJ/PqBamAD+BtKNg3TbW3
	FU8/wAfCmFNeKhJRGfjdq920Aw+1H53GooiXcJDYp5ovgJfPzwFG+PTRo5SnVGSmxzAdkkysS9aaF
	ei2HfJ1RfFzv+5Uw33fmYQAeS3IoN/5U116ayA7OgFy7VyAjPN9bIAHNjSkbA7CovA1OdGLv4huuQ
	tApaQ7jQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tvGWO-000000008B8-1p9s;
	Thu, 20 Mar 2025 15:05:20 +0100
Date: Thu, 20 Mar 2025 15:05:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Eric Garver <eric@garver.life>, Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org,
	Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, pablo@netfilter.org, Kevin Fenzi <kevin@scrye.com>,
	Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8muJWOYP3y-giAP@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8muJWOYP3y-giAP@egarver-mac>

Hi,

I'm comparing this with what we have in RHEL/Fedora:

On Thu, Mar 06, 2025 at 09:16:05AM -0500, Eric Garver wrote:
> On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
[...]
> > diff --git a/files/nftables/main.nft b/files/nftables/main.nft
> > new file mode 100644
> > index 00000000..8e62f9bc
> > --- /dev/null
> > +++ b/files/nftables/main.nft
> > @@ -0,0 +1,24 @@
> > +#!/usr/sbin/nft -f
> > +
> > +# template static firewall configuration file
> > +#
> > +# copy this over to /etc/nftables/rules/main.nft as a starting point for
> > +# configuring a rule set which will be loaded by nftables.service.
> > +
> > +flush ruleset

We do flush here as well, but in our case it's a bit redundant. (See
below.)

> > +
> > +table inet filter {
> > +	chain input {
> > +		type filter hook input priority filter;
> > +	}
> > +	chain forward {
> > +		type filter hook forward priority filter;
> > +	}
> > +	chain output {
> > +		type filter hook output priority filter;
> > +	}
> > +}
> > +
> > +# this can be used to split the rule set into multiple smaller files concerned
> > +# with specific topics, like forwarding rules
> > +#include "/etc/nftables/rules/forwarding.nft"
> > diff --git a/tools/nftables.service.8 b/tools/nftables.service.8
> > new file mode 100644
> > index 00000000..4a83b01c
> > --- /dev/null
> > +++ b/tools/nftables.service.8
> > @@ -0,0 +1,18 @@
> > +.TH nftables.service 8 "" "nftables" "nftables admin reference"
> > +.SH Name
> > +nftables.service \(em Static Firewall Configuration with nftables.service
> > +.SH Description
> > +An nftables systemd service is provided which allows to setup static firewall
> > +rulesets based on a configuration file.
> > +.PP
> > +To use this service, you need to create the main configuration file in
> > +/etc/nftables/rules/main.nft. A template for this can be copied from
> > +/usr/share/doc/nftables/main.nft. The static firewall configuration can be
> > +split up into multiple files which are included from the main.nft
> > +configuration file.
> 
> I think it's worth mentioning that a user could alternatively do:
> 
>   # nft list ruleset > /etc/nftables/rules/main.nft
> 
> to save the entire running ruleset. That's what I do. Mostly because I
> want to make sure runtime accepts it before I make it permanent.
> 
> Perhaps this is not mentioned due to the `flush ruleset`. We could
> suggest saving runtime to a file that's included from main.nft, thus
> retaining the flush.

In RHEL/Fedora, the unit script feeds /etc/sysconfig/nftables.conf into
nft. So this is the "top level" config which by default contains:

| # Uncomment the include statement here to load the default config sample
| # in /etc/nftables for nftables service.
| 
| #include "/etc/nftables/main.nft"
| 
| # To customize, either edit the samples in /etc/nftables, append further
| # commands to the end of this file or overwrite it after first service
| # start by calling: 'nft list ruleset >/etc/sysconfig/nftables.conf'.

The last paragraph is crucial: We want to allow users to either:

- Customize the sample config provided by the distribution (more on that later)
- Extend it by extra ruleset snippets (similar to a /etc/vim/vimrc.local)
- Override the whole thing without much hassle

To support the latter, our unit script does:

| ExecReload=/sbin/nft 'flush ruleset; include "/etc/sysconfig/nftables.conf";'

This way nftables.conf may contain just the output of 'nft list
ruleset', no initial 'flush ruleset' is needed.

The sample configs are not just empty chains as proposed here but
actually contain rules which should not just help users get going but
also showcase nftables features a bit. Also there is mitigation of the
Port Shadow attack (CVE-2021-3773) in the sample nat.nft file:

https://src.fedoraproject.org/rpms/nftables/blob/rawhide/f/main.nft
https://src.fedoraproject.org/rpms/nftables/blob/rawhide/f/router.nft
https://src.fedoraproject.org/rpms/nftables/blob/rawhide/f/nat.nft

IMO we should at least include the builtin 'flush ruleset' in ExecReload
action. What are your opinions about Fedora's sample configs? The
content should be fine for generic purposes, merely
/etc/sysconfig/nftables.conf location should be changed, maybe to
/etc/nftables/nftables.conf.

Cheers, Phil
