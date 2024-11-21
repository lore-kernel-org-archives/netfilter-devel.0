Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E116130B
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208710; cv=none; b=P96/vaDJ1ExSViY3nVzc3qOuvaw3xf/rh6h/Vl+QYLzUN1XFsbKYgDXR3Uy1iFs5sP3CPX6y/hGDKtK1mPdaGdUEuciwzg+rK/sz+3RYM3YhaqY06brwkMCNhDOmntQNdTK9MyG5iN4kHsNuAz7QUPCqJjrlS7KEAr65UF3bMeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208710; c=relaxed/simple;
	bh=C6h1d5ZueEV654e6b+VD1phHPIAh1wdFb3V9IiDMH10=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKmJq+1GESo83+/5IJSM8xCPEeYZYjBNtoSnnOT/7CqibkiCdd6dddZz2yuxta1yjRuGOMhKMrtOq83x4xiRZ4cDE8hIYhNR7NawK/N/biQFaJaPbrJCuoySR9RhDdi37wPlEXmVNowln0bVTnOlX+JhgJm9Bp+izCpOxC+e4as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cCpYbgO9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cCpYbgO9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PxYvjGRvTGZKH1SlXz+Kn+5Qs3bloLgdO9c/vm8dzY8=; b=cCpYbgO9VSTJEI4frSWzDj+Vrm
	VSpbFbtFhJWlhwYAEha+lLFa+zM+24l1fdGZWkWTCiZPdNzX6tLolEVQoL+kuBdYM54dB1Ym8lQA/
	bPJdljRNzHbuPFAx4gUQiTYNPatIjz3wVFD9Fcai64X+9f+FElscTIXv5hvxahfn0+WDwxo2KsptY
	x0T1Ne73KVRZfe0DoaVTUV3lqKgIul3WmQcGKMIeZBWRJjf+GpgolK/450+WdkUoUKUHk1P6XjnQ2
	thGy0HWgsB0fcKyzLT2LQ/IfbpYfRuSAfGhGzPI/BGf9w96wE5bxEjtroKb2yES7J9FiFpmBUPNwb
	XbkGVKgg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tEAbv-000000008Mb-48ed;
	Thu, 21 Nov 2024 18:04:56 +0100
Date: Thu, 21 Nov 2024 18:04:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Message-ID: <Zz9oN_OBdCQ1wlQf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
References: <20241023145730.16896-1-phil@nwl.cc>
 <Zzc3FV4FG8a6px7z@calendula>
 <Zzy4LTNe4a4bepmX@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzy4LTNe4a4bepmX@orbyte.nwl.cc>

Hi,

On Tue, Nov 19, 2024 at 05:09:17PM +0100, Phil Sutter wrote:
[...]
> Checking callers of nft_unregister_flowtable_net_hooks():
> 
> nf_tables_commit() calls it for DELFLOWTABLE, code-paths differ for
> flowtable updates or complete deletions: With the latter,
> nft_commit_release() calls nf_tables_flowtable_destroy() which does the
> UNBIND. So if deleting individual interfaces from an offloaded flowtable
> is supported, we may miss the UNBIND there.
> 
> __nf_tables_abort() calls it for NEWFLOWTABLE. The hooks should have
> been bound by nf_tables_newflowtable() (or nft_flowtable_update(),
> respectively) so this seems like missing UNBIND there.
> 
> Now about __nft_release_hook, I see:
> 
> nf_tables_pre_exit_net
> -> __nft_release_hooks
>   -> __nft_release_hook
> 
> Do we have to UNBIND at netns exit?
> 
> There is also:
> 
> nft_rcv_nl_event
> -> __nft_release_hook
> 
> I don't see where hooks of flowtables in owner flag tables are unbound.

So I validated these findings by adding printks to BIND and UNBIND calls
and performing these actions:

- Delete an interface from a flowtable with multiple interfaces

- Add a (device to a) flowtable with --check flag

- Delete a netns containing a flowtable

- In an interactive nft session, create a table with owner flag and
  flowtable inside, then quit

All these cases cause imbalance between BIND and UNBIND calls. Looking
at possible fixes, I wonder how things are supposed to be: When deleting
a flowtable, nf_tables_commit will unregister hooks (via
nf_unregister_net_hook), but not unlink/free them. Then, in
nft_commit_release, the UNBIND happens along with unlink/free. Is this
the correct process? Namely unregister and wait for RCU grace period
before performing UNBIND? Or is this arbitrary and combining unregister
with UBIND is OK in all cases?

Cheers, Phil
