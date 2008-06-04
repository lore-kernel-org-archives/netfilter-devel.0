From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: xt_connlimit: fix accouning when receive
 RST packet in ESTABLISHED state
Date: Wed, 04 Jun 2008 09:58:01 -0700 (PDT)
Message-ID: <20080604.095801.222375373.davem@davemloft.net>
References: <4846C030.6080707@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59920
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbYFDQ6D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:58:03 -0400
In-Reply-To: <4846C030.6080707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 04 Jun 2008 18:17:52 +0200

> [NETFILTER]: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state
> 
> In xt_connlimit match module, the counter of an IP is decreased when
> the TCP packet is go through the chain with ip_conntrack state TW.
> Well, it's very natural that the server and client close the socket
> with FIN packet. But when the client/server close the socket with RST
> packet(using so_linger), the counter for this connection still exsit.
> The following patch can fix it which is based on linux-2.6.25.4
> 
> Signed-off-by: Dong Wei <dwei.zh@gmail.com>
> Acked-by: Jan Engelhardt <jengelh@medozas.de>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
