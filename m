From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Tue, 31 Aug 2010 20:35:09 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39354 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab0HaSfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:35:11 -0400
In-Reply-To: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-08-31 20:26, Nicola Padovano wrote:

>Hi guys! i know the skb_transport_header to grab the tcp header of a
>packet...so i can write:
>struct tcphdr *tcp_header1 = (struct
>tcphdr*)skb_transport_header(skb), where skb is a certain packet.
>
>now, studying some source code that i've found some days ago, i've seen this:
>
>struct tcphdr *tcp_header2  = (void*)ip_hdr(skb) + ip_hdrlen(skb);
>
>I immediately thought that the two lines were identical, but but I was
>mistaken...in fact if i write this:
>
>printk(KERN_INFO "diff: %d\n",(int)((void*)tcp_header2 - (void*)tcp_header1));
>
>i see, "diff: 20"
>
>so my question is: what's the difference between the two code lines?


skb_transport_header is also explained in the PDF, especially when it 
can not be used.
