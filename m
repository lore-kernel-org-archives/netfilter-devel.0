From: J Sloan <joe@tmsusa.com>
Subject: Re: An oops while running 2.5.65-mm2
Date: Sun, 23 Mar 2003 20:43:03 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3E7E8CD7.3060507@tmsusa.com>
References: <3E7A1ABF.7050402@tmsusa.com>	 <20030320122931.0d2f208f.akpm@digeo.com> <1048209554.1103.21.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:

>This might explain the crashes I've seen in my routers but been unable
>to capture so far (and without the extra slab debugging I don't know if
>I would have been able to find it or even get a decent capture...)
>
>Patch attached that should fix the problem, not tested or even compiled.
>
>Joe, can you please please test it and report back?
>

I've been running 2.5.65-kb2 + your patch
for the past 2 days and everything is fully
functional, with no repeat of the problems
we saw before.

Nice work.

Joe
