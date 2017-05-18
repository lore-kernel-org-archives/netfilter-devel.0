From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_hashlimit: fix 64-bit printf format
Date: Thu, 18 May 2017 16:05:59 +0200
Message-ID: <20170518140559.GA19888@salvia>
References: <1495107808-7207-1-git-send-email-alin.nastac@gmail.com>
 <20170518133730.GA1662@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754777AbdEROGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 10:06:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82DAE192400
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 16:06:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 695BF102187
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 16:06:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFB6B102195
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 16:05:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170518133730.GA1662@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 18, 2017 at 03:37:30PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 18, 2017 at 01:43:28PM +0200, Alin Nastac wrote:
> > Furthermore, this extension use a mix of PRIu64 and %llu formats for
> > uint64_t values. IMO it should use only one, for the sake of consistency.
> > 
> > Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
> > ---
> >  extensions/libxt_hashlimit.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
> > index 9e63e1e..21b7aaa 100644
> > --- a/extensions/libxt_hashlimit.c
> > +++ b/extensions/libxt_hashlimit.c
> > @@ -942,7 +942,7 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
> >  		    _rates[i].mult / avg < _rates[i].mult % avg)
> >  			break;
> >  
> > -	xt_xlate_add(xl, " %llu/%s burst %lu packets",
> > +	xt_xlate_add(xl, " %llu/%s burst "PRIu64" packets",
>                                          ^
>                                        missing % here?

OK, please revamp, thanks.
