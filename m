From: Anton <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024  entries, dropping packets(s). Dropped: 582) - bug or just some defaults  increase required?
Date: Mon, 16 Feb 2009 18:19:27 +0500
Message-ID: <200902161819.27630.anton.vazir@gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <200902121545.16590.anton.vazir@gmail.com> <4996FBBE.20009@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:41151 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZBPNTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:19:47 -0500
In-Reply-To: <4996FBBE.20009@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code for full application is quite a big and overloaded 
with extra functionality like threading, database 
connectivity and so on. We'll try to make a simple 
emulation app to trigger the case and i'll send it.

On Saturday 14 February 2009 22:13, Pablo Neira Ayuso wrote:
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
>
> This means that we expected to receive 1234422229, but we
> got 1234422225 instead. I don't fine any explanation for
> this but this is spotting a problem somewhere (in the
> library or your application) that nfnl_talk silently
> ignores. Could you send me the code that you use to
> trigger this?
>
> Even if you don't have the problem anymore, We have to
> replace that nfnl_talk() which looks broken in several
> aspects.
