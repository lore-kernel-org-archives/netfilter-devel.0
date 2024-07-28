Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535A848E
	for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2024 23:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722208771; cv=none; b=AJARM3ZYwg0dq8GzVxttczh3Dd8uF1Kk7cNYoY7nf/h0CI73bVSzNI9pOXDx66KQ+z7Vi4xYaR0CF4acW+T5gZ5UxPxhQ0mNG7GXRfisgRhJscNw4w8jkID3co1r58srxvlfSIjNadfNpiRz6WBZuBnr03s4G2XB3hynASxuRaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722208771; c=relaxed/simple;
	bh=1g2w73FdMgFRSYSCnRe5KcEZGbz43h9JUs7q4NKEHZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdD9jxOf1tXr73IVyYLsF7e7DdK8lROVRlWgZffvesPpbI4QIBQ6GtNFIwuZtJpZMQV/Rb7iwe/7AIjMMsflRv3x/Y7MJqRYGk/raURD78Xcf3h5aaFFNlqW++/zeVnBI4BzT6MQFGxwY852PkRM8+en0baIBH7VnB/Nn0Jn7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [2001:8a0:74d4:2501:a64e:31ff:febd:17a4] (port=53188 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sYDAZ-008dIm-D4; Mon, 29 Jul 2024 01:19:17 +0200
Date: Mon, 29 Jul 2024 01:19:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <ZqbR0yOY87wI0VoS@calendula>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726123152.GA3778@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Fri, Jul 26, 2024 at 02:31:52PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +*list hooks* is enough to display everything that is active
> > > +on the system, however, it does currently omit hooks that are
> > > +tied to a specific network device (netdev family). To obtain
> > > +those, the network device needs to be queried by name.
> > 
> > IIRC, the idea is to display the ingress path pipeline according to
> > the device (if specified)
> > 
> >         list hooks netdev eth0
> > 
> > as for egress, as it is not possible to know where the packet is
> > going, it is probably good to allow the user to specify the output
> > device, so it gets the entire pipeline for ingress and egress
> > paths, ie.
> > 
> > list hooks netdev eth0 eth1
> 
> Not really, why would eth0 and eth1 be related here?

Note that you can specify:

  list hooks ip device enp0s25

this shows the hooks that will be exercised for a given packet family,
ie. IPv4 packets will exercise the following hooks.

family ip {
        hook ingress {
                 0000000000 chain netdev x y [nf_tables]
        }
        hook prerouting {
                -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
                -0000000200 ipv4_conntrack_in [nf_conntrack]
        }
        hook input {
                 0000000000 chain ip filter in [nf_tables]
                +2147483647 nf_confirm [nf_conntrack]
        }
        hook forward {
                -0000000225 selinux_ip_forward
        }
        hook output {
                -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
                -0000000225 selinux_ip_output
                -0000000200 ipv4_conntrack_local [nf_conntrack]
        }
        hook postrouting {
                +0000000225 selinux_ip_postroute
                +2147483647 nf_confirm [nf_conntrack]
        }
}

This is _not_ showing the list of hooks for a given family.

What I meant is that user could filter out by ingress and egress
device to fetch the hooks that are traversed in such case, ie.

  list hooks ip iifname eth0 oifname eth1

to get the traversal of hooks for IPv4 packets, assuming eth0 as
ingress device and eth1 as egress device.

> What would make more sense to me is to allow
> 
> list hooks netdev
>
> and then have nft fetch list of all network devices and then query them
> all.

Makes sense, it currently fails with EINVAL because no device has been
specified.

> If a packet coming in on devX will be forwarded to devY depends on the
> type of packet and the configuration, e.g. arp/ip vs. bridge/routing
> or even encapsulation...
> 
> > Note that this is not implemented. This has limitations, discovering
> > eth{0,1} belongs to bridge device would need more work (not asking to
> > do this now, but it could be a nice usability feature to discover the
> > pipeline?).
> 
> Bridge?  I don't think we have bridge family support for netdev hooks?
> AFAIU its only netdev and inet.
>
> This thing should only list the nf hooks registered for the device,
> and not start to guess.  So for "list hooks br0", return ingress and
> egress hooks for the virtual device, not the bridge ports.

OK
