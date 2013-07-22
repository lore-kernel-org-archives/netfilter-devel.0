From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Netfilter fixes for net (3.11-rc1)
Date: Mon, 22 Jul 2013 14:34:37 -0700 (PDT)
Message-ID: <20130722.143437.1499715214722844096.davem@davemloft.net>
References: <1374482077-4547-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:34962 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVek (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:34:40 -0400
In-Reply-To: <1374482077-4547-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 22 Jul 2013 10:34:35 +0200

> The following patchset contains Netfilter fixes for your net tree,
> they are:
> 
> * Fix potential NULL dereference in the socket match if revision 0
>   is used, from Eric Dumazet.
> 
> * Fix missing expectation NAT initialization that results in dumping
>   the NAT part via ctnetlink, thus leading to problems in expectation
>   synchronization through conntrackd, from myself.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master

Pulled, thanks Pablo!
