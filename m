From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: CONNMARK: support save the mark of the master
 connection
Date: Thu, 27 Jan 2011 10:49:10 +0100
Message-ID: <4D413F96.2070309@trash.net>
References: <1296121124-7016-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62096 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1A0Jt0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:49:26 -0500
In-Reply-To: <1296121124-7016-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 27.01.2011 10:38, schrieb Changli Gao:
> In some cases(Policy routing), it is expected that all the sub-connections
> share the same mark with their master.

We already automatically mark expected connections with the mark of the
master. What purpose does your patch serve on top of that?

