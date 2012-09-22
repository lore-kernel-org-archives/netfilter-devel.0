From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Bug in limit_mt_check()
Date: Sat, 22 Sep 2012 05:09:29 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209220509060.31062@nerf07.vanv.qr>
References: <505CE985.7000907@infoblox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jim Robinson <jrobinson@infoblox.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40402 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2IVDJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 23:09:32 -0400
In-Reply-To: <505CE985.7000907@infoblox.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ccd netfilter-devel.

On Saturday 2012-09-22 00:26, Jim Robinson wrote:

> Hello
>
> Apologies if I'm directing this email to the wrong people. You two are major
> contributors to the xt_limit module, so I'm hoping that one of you may be able
> to help in sorting out a fix for upstream. If you're not the right people and
> can point me to someone who is, it would be appreciated.
>
> The bug is that under reproducible conditions, it is possible for
> limit_mt_check() to execute and kmalloc() a structure which does not get
> initialized. Specifically, if 'r->cost' is non-zero, 'priv' is kmalloc()ed but
> not initialized. The result of this is that 'priv->prev' and 'priv->credit'
> have bad values in them, and when limit_mt() later executes, it can incorrectly
> return 'true' (not limited) due to these bad values. [FWIW, we observed
> limit_mt() always returning 'true' under these circumstances, with the same bad
> values being present each time]
>
> Additionally, the circumstances for getting limit_mt_check() to execute with
> non-zero 'r->cost' are quite straightforward. Apparently, changes to iptables
> (insertion of a rate limit rule in a chain or replacing an arbitrary rule in a
> chain, to name the two I observed) causes limit_mt_check() to be called with
> non-zero 'r->cost' for each rate limit rule.
>
> I have attached the patch I put together for this bug. The patch is applied
> against the 2.6.32.8 kernel, however, the bug seems to also be in the 3.5
> kernel.
>
> Also attached is some other information I compiled while looking at the bug,
> including some debug traces.
>
> If any additional information is required do not hesitate to ask.
>
> Thanks
> Jim
>
>
>
