From: Oleg <lego12239@yandex.ru>
Subject: Re: libnetfilter_queue & multithreading
Date: Mon, 24 Jul 2017 13:11:26 +0300
Message-ID: <20170724101126.GA19141@legohost>
References: <20170722130849.GA25501@legohost>
 <20170722163855.GB26175@breakpoint.cc>
 <20170724094009.GB19358@legohost>
 <20170724094451.GC26175@breakpoint.cc>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward2j.cmail.yandex.net ([5.255.227.20]:60085 "EHLO
        forward2j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752262AbdGXKJw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 06:09:52 -0400
Content-Disposition: inline
In-Reply-To: <20170724094451.GC26175@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 24, 2017 at 11:44:51AM +0200, Florian Westphal wrote:
> Oleg <lego12239@yandex.ru> wrote:
> > On Sat, Jul 22, 2017 at 06:38:55PM +0200, Florian Westphal wrote:
> > > Oleg <lego12239@yandex.ru> wrote:
> > > > static void*
> > > > thread_start(void *data)
> > > > {
> > > >         struct nfq_handle *h;
> > > >         int fd, n;
> > > >         static char *pkt_buf;
> > > 
> > > static? Looks buggy...
> > 
> >   Hm, why :-)? This function must be local and shouldn't be seen in other
> > source files.
> 
> I was talking about pkt_buf.

Wow. You are right. This is a copy-paste error. Thank you!

-- 
Олег Неманов (Oleg Nemanov)
