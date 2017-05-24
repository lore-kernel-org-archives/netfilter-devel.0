From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Wed, 24 May 2017 18:05:22 +0200
Message-ID: <20170524160522.GA25268@salvia>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com>
 <20170524154419.GA24697@salvia>
 <20170524154615.GB32408@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam Saini <mayhs11saini@gmail.com>,
        netfilter-devel@vger.kernel.org, arturo@debian.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965420AbdEXQFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 12:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F8FCDFE36
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 18:05:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3226F100A47
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 18:05:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3C6F100796
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 18:05:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170524154615.GB32408@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 05:46:15PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, May 24, 2017 at 06:01:51PM +0530, Shyam Saini wrote:
> > > Add translation for cluster to nft
> > 
> > I think this should be:
> > 
> >         -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed 0xdeadbeef
> > 
> > should be translated to:
> > 
> >         jhash ct original saddr mod 2 seed 0xdeadbeef eq 0
> > 
> > if --cluster-local-node is 2, then:
> > 
> >         jhash ct original saddr mod 2 seed 0xdeadbeef eq 1
> 
> Looks good.  But I think we need to take care of mangling pkttype as
> well, right?

We should if we want to 1:1 translation, yes.

Actually, if we rely on the nft arp mac address mangling (to use
multicast ethernet address, ie. RFC violation to cheat dummy switch
just in case you need this to get a packet flooded to two ports), we
could just do this upfront in the ruleset, ie.

        ether daddr 01:00:5e:00:01:01 meta set pkttype host

Using the mac address that we set to arp replies, instead of blind
mangling the mac address.

Anyway, yes, something like:

         jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host

should be good enough.
