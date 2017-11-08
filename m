From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft: I broke interactive mode with iface changes
Date: Thu, 9 Nov 2017 00:47:47 +0100
Message-ID: <20171108234747.GD1788@salvia>
References: <20171108101545.GV32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753089AbdKHXr5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2017 18:47:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8274117720
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2017 00:47:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4516DA807
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2017 00:47:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171108101545.GV32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Wed, Nov 08, 2017 at 11:15:45AM +0100, Phil Sutter wrote:
> Hi,
> 
> When preparing my patch 94a945ffa81b7 ("libnftables: Get rid of explicit
> cache flushes"), I missed that 'nft -i' was explicitly dropping the
> interface cache after every command, so now it won't recognize interface
> changes anymore. Sadly, there is no lightweight method available to
> detect an outdated interface cache like we have with ruleset cache, so I
> played around a bit with alternatives.
> 
> First thing to mention, using the iface cache is considerably faster
> than calling if_nametoindex/if_indextoname each time.

Indeed, this is saving quite a lot of syscall going back and forth due
to netlink socket create, dump, then release under the curtain of
if_nametoindex calls.

> OTOH, I'm not sure having interface indexes in rules is a good idea to
> begin with: A seemingly obvious rule like e.g. 'oif br0 accept' all of a
> sudden stops working if br0 is recreated (typically by restarting
> libvirt or whatever manages it).

For this usecase, people should use iifname instead. Probably we can
insists on this in wiki.nftables.org, if you have an account, I'd
appreciate if you can document this. Same thing for man nft(8).

> This becomes obvious when inspecting the rule set (said rule won't
> print the interface name anymore but just the ifindex value), but
> it's something users have to be aware of first.
> 
> So given that oifname/iifname expressions should be recommended over
> plain oif/iif ones for general-purpose applications, I wonder how
> important that interface cache really is and whether there is a relevant
> drawback when dropping it.
> 
> Getting back to the original issue, I see the following alternatives:
> 
> * Drop interface cache altogether.
> * Make nft_run_cmd_from_*() drop the interface cache before parsing
>   commands.

This is what we were doing before your change, right? So this would be
fine to me.

> * Reintroduce a 'drop_cache()' API function for cli.c to call it.

Thanks.
