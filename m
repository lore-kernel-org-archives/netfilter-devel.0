From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 1/2]: ctnetlink: dump conntrack ID in event messages
Date: Tue, 13 May 2008 23:27:20 -0700 (PDT)
Message-ID: <20080513.232720.200633409.davem@davemloft.net>
References: <48297CA2.3060904@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43713
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYENG10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 02:27:26 -0400
In-Reply-To: <48297CA2.3060904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 13 May 2008 13:33:54 +0200

> [NETFILTER]: ctnetlink: dump conntrack ID in event messages
> 
> Conntrack ID is not put (anymore ?) in event messages. This causes current ulogd2
> code to fail because it uses the ID to build a hash in userspace. This hash is
> used to be able to output the starting time of a connection.
> 
> Conntrack ID can be used in userspace application to maintain an easy match
> between kernel connections list and userspace one. It may worth to add it if
> there is no performance related issue.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> 
> [ Patrick: it was never included in events, but really should be ]
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
