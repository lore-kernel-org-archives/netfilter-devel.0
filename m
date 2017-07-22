From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_queue & multithreading
Date: Sat, 22 Jul 2017 18:38:55 +0200
Message-ID: <20170722163855.GB26175@breakpoint.cc>
References: <20170722130849.GA25501@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43124 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750787AbdGVQkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Jul 2017 12:40:37 -0400
Content-Disposition: inline
In-Reply-To: <20170722130849.GA25501@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
> My program process multiple NFQUEUEs by creating a separate thread
> for every NFQUEUE. An each thread do recv() and nfq_set_verdict2():
[..]

> main()
> {
> ...
>     for(i = 0; i < q_cnt; i++) {
>         ret = pthread_create(&(thread_data[i].id), NULL, thread_start,
>           &thread_data[i].nfq_num);
>         if (ret != 0) {
>             fprintf(stderr, "thread creation error: %s", strerror(ret));
>             exit(EXIT_FAILURE);
>         }
>     }
> ...
> }
> 
> static void*
> thread_start(void *data)
> {
>         struct nfq_handle *h;
>         int fd, n;
>         static char *pkt_buf;

static? Looks buggy...

> Since every thread do nfq_open(), has a separate descriptor and etc, i think
> i don't need a lock around recv() and nfq_set_verdict2(). Am i right?

Yes, as long as all threads have their own receive buffer this
won't need locks.
