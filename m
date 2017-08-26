From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_queue & multithreading & 1 queue freezing
Date: Sat, 26 Aug 2017 21:26:25 +0200
Message-ID: <20170826192625.GD29355@breakpoint.cc>
References: <20170826150738.GA15203@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44388 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751062AbdHZT3D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2017 15:29:03 -0400
Content-Disposition: inline
In-Reply-To: <20170826150738.GA15203@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
>   Hi, all.
> 
> My program process multiple NFQUEUEs by creating a separate thread
> for every NFQUEUE. An each thread do recv() and nfq_set_verdict2():
> 
> But i catch a strange behaviour when more than 1 thread(queue) are
> used. In those cases one queue "freeze" while others works right.
> For example, for 5 queues(here a queue with id 1 "freeze"):

If you use libnetfilter_queue you might need

commit 4ca06bc967d94b7b7b5a6efc76e870f0efc77e24
src: make nfq_open_nfnl thread-safe

(or protect nfq_open_nfnl calls with a mutex).

Other than that I have no idea.
