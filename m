From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 10:51:33 +0100
Message-ID: <20151126095133.GA1612@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35784 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbbKZJvz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 04:51:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9D1976E400
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:51:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8E27ADA86A
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:51:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BEE05DA803
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 10:51:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151125205830.GC1254@unicorn.suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 25, 2015 at 09:58:30PM +0100, Michal Kubecek wrote:
> On Wed, Nov 25, 2015 at 06:20:46PM -0200, Marcelo Ricardo Leitner wrote:
> > Em 25-11-2015 17:42, Pablo Neira Ayuso escreveu:
> > >
> > >Any specific reason ...
> > >
> > >not to have this enable by default?
> > >to have a sysctl switch to enable/disable this?
> > >
> > >Thanks.
> > 
> > Yes, because it can't be used in routers in the middle. That is,
> > unless it's a common hop with the initial path..
> > If it's enabled and this router doesn't see the initial handshake,
> > it won't allow heartbeats to pass and will block all secondary
> > paths.
> > 
> > So if one is already using commit d7ee35190427 and this went on by
> > default, it would break his/her setup.
> 
> This essentially means anyone using SCTP multihoming and conntrack based
> rules as commit db29a9508a92 ("netfilter: conntrack: disable generic
> tracking for known protocols") enforces using the helper. This is where
> the need for basic multihoming support came from: our customer was using
> SCTP multihoming through a firewall with connection tracking but without
> helper (so that only IP addresses were used to match the conntrack); the
> security fix prevented them from doing that.

I would really like to see some scrutiny on the SCTP to get it
embedded into nf_conntrack.

Similar things with other existing protocols that are supported, where
you need to modprobe the protocol to get support for this.

I think this existing behaviour is an anachronism.
