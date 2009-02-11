From: Anton <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 entries, dropping packets(s). Dropped: 582) - bug or just some defaults increase required?
Date: Wed, 11 Feb 2009 13:48:42 +0500
Message-ID: <200902111348.43413.anton.vazir@gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <200902091556.25407.anton.vazir@gmail.com> <49901176.6020502@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:57616 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZBKIsy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:48:54 -0500
In-Reply-To: <49901176.6020502@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'll try to create a test environment for this, since it 
happened in the production PC, so it hard to just try the 
patch on production :)

On Monday 09 February 2009 16:20, Pablo Neira Ayuso wrote:
> Anton wrote:
> > Pablo,
> >
> > Just a little more thought, this happened when my
> > application attempted to create a NEW queue, while in
> > kernel packet queue overrun situation. And after
> > calling the nfq_create_queue there was no return from
> > it, and only error message generation in the loop
> > inside the libnetfilter_queue library. Looks like not a
> > very proper behaviour. Am I missing something?
>
> Oh I see, I did not get the point initially. Does this
> patch fix the problem?
