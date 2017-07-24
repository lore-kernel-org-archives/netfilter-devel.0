From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_queue & multithreading
Date: Mon, 24 Jul 2017 11:44:51 +0200
Message-ID: <20170724094451.GC26175@breakpoint.cc>
References: <20170722130849.GA25501@legohost>
 <20170722163855.GB26175@breakpoint.cc>
 <20170724094009.GB19358@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46356 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751610AbdGXJqf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 05:46:35 -0400
Content-Disposition: inline
In-Reply-To: <20170724094009.GB19358@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
> On Sat, Jul 22, 2017 at 06:38:55PM +0200, Florian Westphal wrote:
> > Oleg <lego12239@yandex.ru> wrote:
> > > static void*
> > > thread_start(void *data)
> > > {
> > >         struct nfq_handle *h;
> > >         int fd, n;
> > >         static char *pkt_buf;
> > 
> > static? Looks buggy...
> 
>   Hm, why :-)? This function must be local and shouldn't be seen in other
> source files.

I was talking about pkt_buf.
