From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 12:40:08 +0200
Message-ID: <20170614104008.GA14452@salvia>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdFNKkO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 06:40:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DCE4278BE9
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 12:40:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E835D1910
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 12:40:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA6F8D1D92
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 12:40:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614095803.GC10130@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 11:58:03AM +0200, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> > I'm curious, What is the use case of using both nftables and iptables
> > at the same time?
> > Some missing functionality in nft?
> > Perhaps some ipt->nft partial migration procedure?
> 
> Yes, partial migration.
> 
> Right now there are an awful lot of tools out there (docker, libvirt,
> kubernetes, ..) that call iptables(-restore) directly (or inject them via
> firewalld).
> 
> And unfortunately I don't see how we can magically move all of this
> to nftables.
>
> So allowing to do a step-by-step migration seems the only viable
> option.

We have iptables-compat-restore, this uses the nf_tables netlink
frontend and packet classification code, plus x_tables extensions to
run iptables code. It should allow us to schedule the x_tables core
for removal at some point.

In Montpellier, we mentioned that distro could add a iptables-restore
symlink to iptables-compat-restore so it becomes visible that we're
relying on the compat infrastructure.

This iptables-compat-restore interacts with nft via translate layer,
so if you just 'nft list ruleset' after using iptables-compat-restore,
you will get a translation (if available).
