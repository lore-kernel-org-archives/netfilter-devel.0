From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: "notification events for routing changes" patch
Date: Tue, 17 Nov 2015 09:28:25 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511170925540.19459@blackhole.kfki.hu>
References: <D26FEC66.2884B%msezgin@codeaurora.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Murat Sezgin <msezgin@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58914 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbKQI0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 03:26:43 -0500
In-Reply-To: <D26FEC66.2884B%msezgin@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Nov 2015, Murat Sezgin wrote:

> While I was looking for a solution in the kernel for general routing
> change notification implementation, I came across your following patch.
> 
> http://www.spinics.net/lists/netfilter-devel/msg24239.html
> 
> In this email chain, you said that you found another simple solution and
> implemented it in the masquerade module. I saw that commit in the upstream
> kernel.
> 
> But I think the patch you proposed before also very useful for the fast
> path implementations. Because when a connection starts to flow through the
> fast path, linux networking stack no longer sees those packets. Then, if
> the route table is changed in some way, let?s say user add/delete a route
> with the ?route? or ?ip route? command, the fast path traffic will not
> aware of this change. So, if we have a notification mechanism like you
> have implemented, the fast path manager module can register itself to
> these events and manage its connections accordingly.
> 
> Do you have any plan to push and merge this path to the upstream kernel?

No, the patch was inefficient from conntrack point of view and finally the 
patch "Handle routing changes in MASQUERADE target, v4" went into the 
kernel:

http://www.spinics.net/lists/netfilter-devel/msg24276.html

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
