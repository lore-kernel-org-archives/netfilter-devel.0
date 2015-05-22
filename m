From: Loganaden Velvindron <logan@elandsys.com>
Subject: Re: Harden iptables memory allocator
Date: Fri, 22 May 2015 04:51:48 -0700
Message-ID: <20150522115148.GA1985@mx.elandsys.com>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com>
 <1432284611.3364.14.camel@stressinduktion.org>
 <alpine.LSU.2.20.1505221056510.29609@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Loganaden Velvindron <loganaden@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:62474 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbbEVLwE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2015 07:52:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1505221056510.29609@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 22, 2015 at 10:59:44AM +0200, Jan Engelhardt wrote:
> 
> On Friday 2015-05-22 10:50, Hannes Frederic Sowa wrote:
> >
> >> + if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
> >
> >if ((nmemb|size) >= MUL_NO_OVERFLOW) && ...
> 
> I am sure there are many C tricks one can do, but iptables is
> hardly that time-critical to warrant such.

The same can be said of ipset, which uses strlcpy and has strlcat in 
its library. However, those are safer APIs to use.

In this particular case, it's safer to use reallocarray(NULL,x,y) rather than
malloc(x*y).


(Many other less critical software such as m4 have also adopted reallocarray).

> The compiler should perhaps learn to do such an optimization
> if it does not already.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
