From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync
 option
Date: Mon, 8 May 2017 19:47:16 +0200
Message-ID: <20170508174715.GA21690@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
 <20170425113732.GB5355@salvia>
 <CAOkSjBiYGg76HichZbLkmyHyHTV3OPu3H7BqSE1ZJki0gh7pxA@mail.gmail.com>
 <20170425131843.GB1050@salvia>
 <CAOkSjBj3wqnCVMAfMek3NKbgbo35EjMQ842gOzgOpmH=qBu=6g@mail.gmail.com>
 <20170501091319.GA2925@salvia>
 <CAOkSjBjBMjfx1VHAtH1z+4fV-hzLWp_O7DGwg4sACB+U_vGgzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbdEHRrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:47:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49289209935
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:47:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A9C91BA10C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:47:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13F691BA10B
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:47:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBjBMjfx1VHAtH1z+4fV-hzLWp_O7DGwg4sACB+U_vGgzg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 02, 2017 at 10:18:55AM +0200, Arturo Borrero Gonzalez wrote:
> On 1 May 2017 at 11:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >> the ALARM mode requires to commit the external cache instead of the
> >> conns being directly injected into the kernel.
> >
> > You may want to disable the external cache with the alarm mode. The
> > alarm mode only needs the internal cache though, but that shouldn't be
> > much of a problem.
> >
> > With the alarm mode, you will skip spikes in CPU consumption since
> > resync is expensive.  With a very large table, this results in some
> > sort of lazy busy polling.
> >
> 
> I do the equivalent of this RequestResync by hand (i.e. using conntrackd -n) and
> it seems to work fine, see below.

OK.

> >> I think the new RequestResync method (or whatever other alternative)
> >> provides a good tradeoff between methods and increases general
> >> usefulness of conntrackd.
> >
> > I'm trying to help here if I can give something better ;-)
> >
> > Look, you should at least combine this new RequestResync with
> > CommitTimeout. Even if you don't explicitly request a commit command,
> > this sets the timeout for the entries that are pushed into the kernel.
> >
> > So, if you set:
> >
> >         RequestResync 30
> >         CommitTimeout 180
> >
> > connections we don't get any information from for 180 seconds will
> > expire.
> >
> 
> It seems that CommitTimeout can't be combined with
> DisableExternalCache, see the evaluate() function.
>
> However a patch to enable this seems easy. I guess we could extend a
> bit external_inject_ct_new() to allow reading the commit_timeout
> instead of using 0 (similar to what cache_ct_commit_step() does,
> right?)
> 
> I can add a new previous patch to the series to enable this.
> 
> > BTW, how are you measuring this improvement? Is that you get less logs
> > error messages that you reported before or so?
> >
> 
> What I detect is that after the initial startup/sync, the amount of
> conntracks in each node diverges.
> After 10 minutes, the conntracks in each node are quite different, i.e:
> 
> aborrero@node1:~ $ sudo conntrack -C
> 7885
> 
> aborrero@node2:~ $ sudo conntrack -C
> 17813
> 
> A manual 'conntrackd -n' seems to solve the problem:
> 
> aborrero@node1:~ $ sudo conntrackd -n ; sudo conntrack -C
> 18583
> 
> aborrero@node2:~ $ sudo conntrackd -n ; sudo conntrack -C
> 18473
> 
> I can understand that each node sees different traffic (is a
> multi-master symmetric configuration) but still,
> according to my conntrackd setup, I understand that the numbers
> shouldn't show that big divergence.
>
> Then, in this scenario, if node2 failover to node1, there are 10k
> entries missing in node1, connections that will be presumably lost and
> dropped by the stateful configuration of nftables.
> 
> I currently solve this by means of scripts and cron calls which is a
> bit ugly, given how easy could be for conntrackd to resync by himself.
> 
> You may ask, what kind of traffic does each node see? In my current
> setup, node1 sees all the IPv4 traffic and node2 sees all the IPv6
> traffic (or reverse). In case of failover, a sigle node can see all
> the traffic.

OK, so there is no assymmetric path at all as node1 sees IPv4 traffic
coming both in original and reply direction.

This is strange, there is probably a more fundamental bug here, I
would like that we're not papering this with a new option.

I'm going to reproduce this in my testbed and get back to you.
