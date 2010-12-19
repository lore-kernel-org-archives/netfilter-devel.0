From: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 19:23:32 +0100
Message-ID: <1292783012.2321.24.camel@kushiel.sterenborg.info>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
	 <1292657351.2371.73.camel@kushiel.sterenborg.info>
	 <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from firehole.xs4all.nl ([82.95.248.56]:38312 "EHLO
	smtp.sterenborg.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab0LSSX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 13:23:57 -0500
In-Reply-To: <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2010-12-18 at 12:13 +0100, Jozsef Kadlecsik wrote:
> Hi Rob,

[...]

> Your kernel header files at the default location is not recent enough.

That's entirely possible and I suppose it's the same pitfall I fell in
when compiling libmnl. :-/ I installed kernel 2.6.36.2 but didn't copy
it's header files into /usr/include, where ipset would pick them up.
Since I have no intention to go back to 2.6.18, I'm going to copy the
header files and try everything again to see what happens.

> I'm undecided yet how to solve it: maybe it should be checked by configure 
> and fail immediately.

I suppose you shouldn't do anything (yet?) because of the above.


Thanks,
Rob


