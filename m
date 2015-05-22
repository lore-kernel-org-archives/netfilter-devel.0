From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Harden iptables memory allocator
Date: Fri, 22 May 2015 10:59:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505221056510.29609@nerf40.vanv.qr>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com> <1432284611.3364.14.camel@stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Loganaden Velvindron <loganaden@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:50269 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbbEVI7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2015 04:59:45 -0400
In-Reply-To: <1432284611.3364.14.camel@stressinduktion.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-05-22 10:50, Hannes Frederic Sowa wrote:
>
>> + if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
>
>if ((nmemb|size) >= MUL_NO_OVERFLOW) && ...

I am sure there are many C tricks one can do, but iptables is
hardly that time-critical to warrant such.
The compiler should perhaps learn to do such an optimization
if it does not already.
