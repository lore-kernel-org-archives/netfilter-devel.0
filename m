From: Oleg <lego12239@yandex.ru>
Subject: Re: libnetfilter_queue & multithreading & 1 queue freezing
Date: Sun, 27 Aug 2017 15:19:00 +0300
Message-ID: <20170827121900.GA25231@legohost>
References: <20170826150738.GA15203@legohost>
 <20170826192625.GD29355@breakpoint.cc>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward106p.mail.yandex.net ([77.88.28.109]:50619 "EHLO
        forward106p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbdH0MQz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Aug 2017 08:16:55 -0400
Content-Disposition: inline
In-Reply-To: <20170826192625.GD29355@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 26, 2017 at 09:26:25PM +0200, Florian Westphal wrote:
> Oleg <lego12239@yandex.ru> wrote:
> >   Hi, all.
> > 
> > My program process multiple NFQUEUEs by creating a separate thread
> > for every NFQUEUE. An each thread do recv() and nfq_set_verdict2():
> > 
> > But i catch a strange behaviour when more than 1 thread(queue) are
> > used. In those cases one queue "freeze" while others works right.
> > For example, for 5 queues(here a queue with id 1 "freeze"):
> 
> If you use libnetfilter_queue you might need
> 
> commit 4ca06bc967d94b7b7b5a6efc76e870f0efc77e24
> src: make nfq_open_nfnl thread-safe
> 
> (or protect nfq_open_nfnl calls with a mutex).

A mutex around nfq_open() seems to work. At least, 30 restarts
didn't show a frozen on recvfrom() queue.

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
