From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/7] netfilter fixes for 3.0.0-rc1 (try 2)
Date: Sun, 05 Jun 2011 17:15:26 -0700 (PDT)
Message-ID: <20110605.171526.465829039753091229.davem@davemloft.net>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:41451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1FFAQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:16:31 -0400
In-Reply-To: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Mon,  6 Jun 2011 02:11:33 +0200

> - fix compilation warning in conntrack with recent gcc versions by Eric.
> 
> - a couple of minor fixes for ipset from Jozsef.
> 
> - one fix for IPVS with SNAT from Julian Anastasov.
> 
> - one fix for NAT and checksumming also from Julian.
> 
> - fix refcount leak in conntrack with ICMP[v6] by myself.
> 
> You can pull them from:
> 
> git://1984.lsi.us.es/net-2.6 pablo/nf-2.6-updates

Pulled, thanks a lot!
