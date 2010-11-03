From: Patrick McHardy <kaber@trash.net>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 08:37:44 +0100
Message-ID: <4CD11148.2060204@trash.net>
References: <20101102.135254.226783976.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44384 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0KCHhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:37:46 -0400
In-Reply-To: <20101102.135254.226783976.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.11.2010 21:52, David Miller wrote:
> 
> H. Peter Anvin just mentioned something interesting to me,
> basically it's the fact that when your prefix addresses
> change on an interface in ipv6, this can invalidate your
> netfilter rules.
> 
> So it would be nice if there were some way to match "the
> ipv6 prefix address on interface X", and through some
> kind of caching this could be optimized so it wouldn't
> really cost anything.
> 
> Thoughts?

Perhaps something similar to the IPv4 addrtype match would work?
Basically it allows you to match on inet_addr_type() of the source
or destination address.
