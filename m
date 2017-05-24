From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: prevent using sets in payload statements
Date: Wed, 24 May 2017 17:49:06 +0200
Message-ID: <20170524154906.GA24991@salvia>
References: <149563146450.21555.7985467199304693684.stgit@nfdev2.cica.es>
 <20170524154820.GC24697@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752668AbdEXPtQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 11:49:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A141DFE31
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:49:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B473FF6FD
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:49:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C386A0AAC
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:49:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170524154820.GC24697@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 05:48:20PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 24, 2017 at 03:11:04PM +0200, Arturo Borrero Gonzalez wrote:
> > Prevent this assert:
> > 
> > % nft [..] tcp dport set { 0 , 1 }
> > BUG: unknown expression type set reference
> > nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
> > Aborted
> > 
> > We can't use a set here because we will not known what value to use.
> > 
> > With this patch, this is produced:
> > 
> > % nft [..] tcp dport set {1, 2 }
> > <cmdline>:1:19-27: Error: you cannot use a set here
> > add rule ip nat c tcp dport set {1, 2 }
> >                   ^^^^^^^^^~~~~~~~~~~~~
> > % nft [..] tcp dport set @s
> > <cmdline>:1:19-27: Error: you cannot reference a set here
> > add rule ip nat c tcp dport set @s
> >                   ^^^^^^^^^~~~~~~~
> > 
> > Using maps is still allowed:
> > 
> > % nft [..] tcp dport set numgen inc mod 2 map { 0 : 4040 , 1 : 4050 }
> 
> Good catch.
> 
> I think we should reject this more generically, ie.
> 
> nft add rule x y meta mark set {1, 2 }

I mean, the example above is not payload, but it should be rejected
too.
