From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: tcp: Use TCP_MAX_WSCALE instead of
 literal 14
Date: Wed, 19 Apr 2017 21:57:55 +0200
Message-ID: <20170419195755.GA16404@salvia>
References: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>
 <20170419155822.GA8603@salvia>
 <1492618928.22296.2.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gfree.wind@foxmail.com, netfilter-devel@vger.kernel.org,
        Gao Feng <fgao@ikuai8.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935696AbdDST6S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 15:58:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D607AC1269
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 21:58:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B97EFDA7E9
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 21:58:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3643CDA807
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 21:57:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492618928.22296.2.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 19, 2017 at 09:22:08AM -0700, Eric Dumazet wrote:
> On Wed, 2017-04-19 at 17:58 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Apr 19, 2017 at 09:23:42AM +0800, gfree.wind@foxmail.com wrote:
> > > From: Gao Feng <fgao@ikuai8.com>
> > > 
> > > The window scale may be enlarged from 14 to 15 according to the itef
> > > draft https://tools.ietf.org/html/draft-nishida-tcpm-maxwin-03.
> > > 
> > > Use the macro TCP_MAX_WSCALE to support it easily with TCP stack in
> > > the future.
> > 
> > Applied, thanks.
> 
> Note that linux kernel is not ready yet for a TCP_MAX_WSCALE being
> changed to 15.
> 
> Signed 32bit sk counters can already be abused with 1GB TCP windows, for
> malicious peers sending SACK forcing linux to increase its memory usage
> above 2GB and overflows are pretty bad.

We have tend to use our own definitions for the TCP connection
tracking so far. This one I checked it refers RFC1323 too.

If this semantics may change from one way to another in a way that may
break conntracking, please let me know, I can toss it here.

Thanks Eric!
