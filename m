Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C63710E4
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2024 00:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722212514; cv=none; b=bUZTALVClGaNWrsNy/nxYMrBHoaiKx9+LOlbXdVqPpzfKbvdjP9KmEj/OAAY2Vgek/5IJrIKQN6jt6qhS+WcZlXLzTHliv5SS+F7mYWer3blImkPcfFScTH9WjAsxgXqlzdXlQpyuYMj/WOYnZCGAVtG1y7pJpbm+C062dNEiLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722212514; c=relaxed/simple;
	bh=5eChBArmE+dQiKdlCf1JOWSZFGqMjuTjiZgEN9V1QPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pu0jM0Nrhgk2pep89IsUNF/qgRN1vtL0711gmLvSNl21/m65GNhdyTF1zPcpLzbK5//ZkNqsD1WrFSj3FKHrwMBUX/v0sHntcxGkf5U/6Z3lv3NonZYzikDVK4TZ4pu1Jb9aRNxKuxE1HWKYj+NbBgFOUf3piGmuu3masV2gvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [2001:8a0:74d4:2501:a64e:31ff:febd:17a4] (port=46026 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sYE93-008hCn-Ck; Mon, 29 Jul 2024 02:21:47 +0200
Date: Mon, 29 Jul 2024 02:21:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <ZqbgmMzuOQShJWXK@calendula>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240728233736.GA31560@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Jul 29, 2024 at 01:37:36AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Not really, why would eth0 and eth1 be related here?
> > 
> > Note that you can specify:
> > 
> >   list hooks ip device enp0s25
> > 
> > this shows the hooks that will be exercised for a given packet family,
> > ie. IPv4 packets will exercise the following hooks.
> > 
> > family ip {
> >         hook ingress {
> >                  0000000000 chain netdev x y [nf_tables]
> >         }
> >         hook prerouting {
> >                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
> >                 -0000000200 ipv4_conntrack_in [nf_conntrack]
> >         }
> >         hook input {
> >                  0000000000 chain ip filter in [nf_tables]
> >                 +2147483647 nf_confirm [nf_conntrack]
> >         }
> >         hook forward {
> >                 -0000000225 selinux_ip_forward
> >         }
> >         hook output {
> >                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
> >                 -0000000225 selinux_ip_output
> >                 -0000000200 ipv4_conntrack_local [nf_conntrack]
> >         }
> >         hook postrouting {
> >                 +0000000225 selinux_ip_postroute
> >                 +2147483647 nf_confirm [nf_conntrack]
> >         }
> > }
> > 
> > This is _not_ showing the list of hooks for a given family.
> 
> I now realize that whats in the tree today is not what I wrote originally.

We agreed to change it.

> So this is neither showing the hooks that will be execrised (packet
> can't be input and forward...).  But ok.  I don't know what to do now.

As it is not possible to know where the packet is going (input /
forward), this listing represents what hooks can be potentially
exercised for such packet family, hence, netdev hooks are included in
the ip family view.

If you don't like this behaviour and prefer a strict view per hook
family it should be possible to revisit. User will have to get all the
pieces together to understand what the hook pipeline is instead. This
command has not been documented so far.

> > What I meant is that user could filter out by ingress and egress
> > device to fetch the hooks that are traversed in such case, ie.
> > 
> >   list hooks ip iifname eth0 oifname eth1
> > 
> > to get the traversal of hooks for IPv4 packets, assuming eth0 as
> > ingress device and eth1 as egress device.
> 
> No idea how to make this, or I fail to understand.

Not important for this series, this can be extended later.

> > > What would make more sense to me is to allow
> > > 
> > > list hooks netdev
> > >
> > > and then have nft fetch list of all network devices and then query them
> > > all.
> > 
> > Makes sense, it currently fails with EINVAL because no device has been
> > specified.
> 
> I'll try to add it, but I don't know if I should toss these patches
> first or not :/

I think patchset looks fine, but documentation update needs a revamp
if you agree in the existing behaviour.
