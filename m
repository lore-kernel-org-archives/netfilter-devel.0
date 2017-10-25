From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Thu, 26 Oct 2017 01:47:46 +0200
Message-ID: <20171025234746.GA4172@salvia>
References: <1508949114.1154.14.camel@cohaesio.com>
 <20171025175725.GJ19457@breakpoint.cc>
 <1508955630.25035.13.camel@cohaesio.com>
 <1508970133.25035.24.camel@cohaesio.com>
 <20171025224536.GK19457@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdJYXru (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 19:47:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7615AE0428
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 01:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68291DA86D
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 01:47:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171025224536.GK19457@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 26, 2017 at 12:45:36AM +0200, Florian Westphal wrote:
> Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> > On ons, 2017-10-25 at 20:20 +0200, Anders K. Pedersen | Cohaesio wrote:
> > > On ons, 2017-10-25 at 19:57 +0200, Florian Westphal wrote:
> > > > Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
[...]
> > > As mentioned, it's not consistent. A rule that has worked fine could
> > > suddenly stop working without any rule set changes for days. Some
> > > times
> > > it has helped to just reload the exact same rule set. Other times
> > > changing
> > > 
> > > tcp dport { imap2, imaps } flow table imap \
> > >                 { ip saddr & 255.255.255.240 \
> > >                   timeout 5m limit rate 10/minute } \
> > >         counter accept
> > > 
> > > to
> > > 
> > > tcp dport { imap2, imaps } flow table imap \
> > >         counter accept
> > > 
> > > or
> > > 
> > > tcp dport { domain, http, https, 8080, 8443, 9091 } \
> > >         meta iif eth1 accept
> > > 
> > > to
> > > 
> > > tcp dport { domain, http, https, 8080, 8443, 9091 } \
> > >         meta iif eth1 counter accept
> > > 
> > > has resolved it, but it feels like it wasn't really due to the
> > > changes,
> > > but more random luck.
> 
> note that sets are broken with 16bit elements at the moment in 4.13, see
> 
> https://patchwork.ozlabs.org/patch/821080/
> or
> https://patchwork.ozlabs.org/patch/830236/

JFYI, the fix for sets is now in nf.git.

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/

I swear this was included in the previous batch, but it was not. Sorry
about this. Will send this upstream asap.
