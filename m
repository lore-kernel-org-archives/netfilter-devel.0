From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 16:16:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106091615510.31505@frira.zrqbmnf.qr>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com> <alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr> <BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tihomir Katic <tihomir.katic@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:37871 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1FIOQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:16:58 -0400
In-Reply-To: <BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-06-09 16:07, Tihomir Katic wrote:
>
>Also, I have been doing some tests, and in config.txt you will see:
>## Optimal size of multiport - port array
>port_array_size_optimal = 10
>
>It means, it will merge 2 rules for example --dport 1:5 and --dport
>21:25 into -m multiport --dports 1,2,3,4,5,21,22,23,24,25

This should be -m multiport --dports 1:5,21:25

>But, based on my recent tests, it should be
>port_array_size_optimal = 15

Yes, multiport can hold 15 "things".

>rule with  --dport 1:5  takes e.g. ~0.2 us
>and rule with 15 elements in multiport array lasts ~0.4us, so it is
>pretty much the same

That is purely noise. You need a lot more rules (10000 and up) to 
measure an effect.
