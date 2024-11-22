Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C957B5223
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732282780; cv=none; b=YJliqwONwJVjsfQfAOzCJzfAj3zoQSy8Drm0CD/2P8e5SDSXys9HTwQG37dzxdgWX2jseZrxKslrDCwcUJW5rzmbLyQWOSXr8UlaPv0N2TwZXP0mqkzeReqz53LzmGSsWTbWxfUv4Cd6/uhr3U6QH3KaWBEj8Sqyk5gTZgl68/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732282780; c=relaxed/simple;
	bh=TzeZqYGyqmtQw1J1Sd8jE3VwQ/omW3wKoiljLDiRt3U=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfeXKf+aeDejD7WkAnZyXaW6ubEIgbfIBjzTaTypBGRXI/eDmkoFvFlwU3ENQ2abhCfXVuvXzr0+P6CowTA5jK2LojzH24R7ir5oL+PbEw6Sc0Jp/D2P87Bzc4YxWlg4jxPIiGQ7OxthKIwyTZ5/PPlmptvmjN02kiqey5AU1kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=34452 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tETsh-000m9C-W4; Fri, 22 Nov 2024 14:39:34 +0100
Date: Fri, 22 Nov 2024 14:39:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Message-ID: <Z0CJkzhOls1Dr4N2@calendula>
References: <20241023145730.16896-1-phil@nwl.cc>
 <Zzc3FV4FG8a6px7z@calendula>
 <Zzy4LTNe4a4bepmX@orbyte.nwl.cc>
 <Zz9oN_OBdCQ1wlQf@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zz9oN_OBdCQ1wlQf@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Nov 21, 2024 at 06:04:55PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Tue, Nov 19, 2024 at 05:09:17PM +0100, Phil Sutter wrote:
> [...]
> > Checking callers of nft_unregister_flowtable_net_hooks():
> > 
> > nf_tables_commit() calls it for DELFLOWTABLE, code-paths differ for
> > flowtable updates or complete deletions: With the latter,
> > nft_commit_release() calls nf_tables_flowtable_destroy() which does the
> > UNBIND. So if deleting individual interfaces from an offloaded flowtable
> > is supported, we may miss the UNBIND there.
> > 
> > __nf_tables_abort() calls it for NEWFLOWTABLE. The hooks should have
> > been bound by nf_tables_newflowtable() (or nft_flowtable_update(),
> > respectively) so this seems like missing UNBIND there.
> > 
> > Now about __nft_release_hook, I see:
> > 
> > nf_tables_pre_exit_net
> > -> __nft_release_hooks
> >   -> __nft_release_hook
> > 
> > Do we have to UNBIND at netns exit?
> > 
> > There is also:
> > 
> > nft_rcv_nl_event
> > -> __nft_release_hook
> > 
> > I don't see where hooks of flowtables in owner flag tables are unbound.
> 
> So I validated these findings by adding printks to BIND and UNBIND calls
> and performing these actions:
> 
> - Delete an interface from a flowtable with multiple interfaces
> 
> - Add a (device to a) flowtable with --check flag
> 
> - Delete a netns containing a flowtable
> 
> - In an interactive nft session, create a table with owner flag and
>   flowtable inside, then quit
> 
> All these cases cause imbalance between BIND and UNBIND calls. Looking
> at possible fixes, I wonder how things are supposed to be: When deleting
> a flowtable, nf_tables_commit will unregister hooks (via
> nf_unregister_net_hook), but not unlink/free them. Then, in
> nft_commit_release, the UNBIND happens along with unlink/free. Is this
> the correct process? Namely unregister and wait for RCU grace period
> before performing UNBIND? Or is this arbitrary and combining unregister
> with UBIND is OK in all cases?

Thanks for the detailed report.

Basically, add/delete interface to an existing flowtable is not
supported by hardware offload at this stage, one option is to reject
this by now.

Then, netns integration was never considered, because it was not clear
to me how hardware offload mix with containers at this stage. This
needs to be fixed. Same applies interactive nft session (owner flag).

This is my mess, let me post a fix so we can soonish clean the way for
you to follow up on your effort to allow for dynamic interface
bindings in the next merge window once this fix gets to net.git.

Thanks.
