From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 02/16] Implement IP_TRANSPARENT socket option
Date: Wed, 01 Oct 2008 07:30:36 -0700 (PDT)
Message-ID: <20081001.073036.47033561.davem@davemloft.net>
References: <20081001142431.4893.48078.stgit@este>
	<20081001142431.4893.69747.stgit@este>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: hidden@sch.bme.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50389
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYJAOas (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:30:48 -0400
In-Reply-To: <20081001142431.4893.69747.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: KOVACS Krisztian <hidden@sch.bme.hu>
Date: Wed, 01 Oct 2008 16:24:31 +0200

> This patch introduces the IP_TRANSPARENT socket option: enabling that will make
> the IPv4 routing omit the non-local source address check on output. Setting
> IP_TRANSPARENT requires NET_ADMIN capability.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Applied to net-next-2.6
