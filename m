From: Anton <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024  entries, dropping packets(s). Dropped: 582) - bug or just some defaults  increase required?
Date: Sat, 14 Feb 2009 14:03:28 +0500
Message-ID: <200902141403.28614.anton.vazir@gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <200902121545.16590.anton.vazir@gmail.com> <4994196F.7030400@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:36137 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZBNJDi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:03:38 -0500
In-Reply-To: <4994196F.7030400@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Today (unpatched) case happened with increased buffer size 
to 10240, nice=0, trying with nice=-15
No dmesg messages on overflows. Just loop again. 
Patch yet not usable, since returns failure too often on 
queue creation. Any update from you?

Regards,
Anton.

On Thursday 12 February 2009 17:43, Pablo Neira Ayuso wrote:
> Anton wrote:
> > Pablo,
> >
> > Some more info. After applying the patch, If we do try
> > to just create 100 QUEUE's by the test code - on the
> > test PC, with _no_ transit traffic, routed to QUEUE's -
> > it works fine, queues created with no problem.
> > But if we do this on the live PC, with trasit traffic
> > routed to queues - we came to the problem once in a few
> > queues. We localized the place, and the sequence is as
> > follows: nfnl_query=>nfnl_catch=>nfnl_process
> >
> > and in the nfnl_process
> >
> > if (nlh->nlmsg_seq && nlh->nlmsg_seq != h->seq) {
> >                 errno = EILSEQ;
> >                 return -1;
> > }
> >
> > and varibales are
> > nlh->msg_seq=1234422225, h->seq=1234422229.
> >
> > EILSEQ=84
> > strerr(84) returns "Invalid or incomplete multibyte or
> > wide character"
> >
> > Any clue on this?
>
> There's some race condition. It seems that you're
> receiving packets from kernel-space to nfqueue before the
> ACK message from kernel-space to user-space to confirm
> subscription is send. Let me investigate this. Thanks for
> the accurate report.
