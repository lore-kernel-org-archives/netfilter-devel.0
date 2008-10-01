From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 07/16] Make Netfilter's ip_route_me_harder()
 non-local address compatible
Date: Wed, 01 Oct 2008 07:45:34 -0700 (PDT)
Message-ID: <20081001.074534.98891550.davem@davemloft.net>
References: <20081001142431.4893.48078.stgit@este>
	<20081001142431.4893.46493.stgit@este>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: hidden@sch.bme.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45005
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbYJAOpq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:45:46 -0400
In-Reply-To: <20081001142431.4893.46493.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: KOVACS Krisztian <hidden@sch.bme.hu>
Date: Wed, 01 Oct 2008 16:24:31 +0200

> Netfilter's ip_route_me_harder() tries to re-route packets either generated or
> re-routed by Netfilter. This patch changes ip_route_me_harder() to handle
> packets from non-locally-bound sockets with IP_TRANSPARENT set as local and to
> set the appropriate flowi flags when re-doing the routing lookup.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Applied to net-next-2.6, but obviously without the parts
I had to backport into patch 6
