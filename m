From: Anton <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 entries, dropping packets(s). Dropped: 582) - bug or just some defaults increase required?
Date: Mon, 9 Feb 2009 15:56:24 +0500
Message-ID: <200902091556.25407.anton.vazir@gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <498E3693.6030702@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:41227 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZBILDQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:03:16 -0500
In-Reply-To: <498E3693.6030702@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Just a little more thought, this happened when my 
application attempted to create a NEW queue, while in 
kernel packet queue overrun situation. And after calling 
the nfq_create_queue there was no return from it, and only 
error message generation in the loop inside the 
libnetfilter_queue library. Looks like not a very proper 
behaviour. Am I missing something?

With best regards,
Anton.

On Sunday 08 February 2009 06:34, Pablo Neira Ayuso wrote:
> Anton VG wrote:
> > Hello Friends,
> >
> > Just came to a problem with nfnetlink_queue -
> >
> > I've created a service where users do connect to a
> > host, and every connected user (over PPP) get's a
> > separate NF-QUEUE - In this QUEUE i do packet
> > accounting, to a different destination. When number of
> > simultaneous queues went to 40+  I just came to a
> > problem - deadloop with continues generation of the
> > error to stderr - (3GB of record in the log in 3
> > minutes of deadlock)
> >
> > nfnl_talk: recvmsg over-run
>
> This happens when netlink fails to deliver a packet from
> kernel to userspace due to an overrun in the buffer.
>

