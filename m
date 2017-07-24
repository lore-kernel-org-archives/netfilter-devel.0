From: Oleg <lego12239@yandex.ru>
Subject: Re: libnetfilter_queue & multithreading
Date: Mon, 24 Jul 2017 12:40:09 +0300
Message-ID: <20170724094009.GB19358@legohost>
References: <20170722130849.GA25501@legohost>
 <20170722163855.GB26175@breakpoint.cc>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward1p.cmail.yandex.net ([77.88.31.16]:42785 "EHLO
        forward1p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751537AbdGXJpr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 05:45:47 -0400
Content-Disposition: inline
In-Reply-To: <20170722163855.GB26175@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 22, 2017 at 06:38:55PM +0200, Florian Westphal wrote:
> Oleg <lego12239@yandex.ru> wrote:
> > static void*
> > thread_start(void *data)
> > {
> >         struct nfq_handle *h;
> >         int fd, n;
> >         static char *pkt_buf;
> 
> static? Looks buggy...

  Hm, why :-)? This function must be local and shouldn't be seen in other
source files.


-- 
Олег Неманов (Oleg Nemanov)
