From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipv6: netfilter: move xfrm_lookup at end of ip6_route_me_harder
Date: Thu, 15 Apr 2010 12:37:52 +0200
Message-ID: <4BC6EC80.10307@trash.net>
References: <20100415094208.GA7770@babylon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <uweber@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60733 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0DOKhx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:37:53 -0400
In-Reply-To: <20100415094208.GA7770@babylon>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulrich Weber wrote:
> xfrm_lookup should be called after ip6_route_output skb_dst_set,
> otherwise skb_dst_set of xfrm_lookup is pointless
> 

Applied, thanks Ulrich.
