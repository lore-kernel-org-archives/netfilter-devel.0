From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 6/8] netfilter: ipt_CLUSTERIP: use proto_ports_offset()
 to support AH message
Date: Thu, 19 Aug 2010 17:17:47 -0700 (PDT)
Message-ID: <20100819.171747.191385421.davem@davemloft.net>
References: <1282107952-3624-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49319
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab0HTARa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:17:30 -0400
In-Reply-To: <1282107952-3624-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 18 Aug 2010 13:05:52 +0800

> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

I applied the updated v2 version of this patch.
