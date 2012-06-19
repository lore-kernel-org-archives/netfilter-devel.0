From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] netfilter updates for net-next (batch 3)
Date: Mon, 18 Jun 2012 20:28:43 -0700 (PDT)
Message-ID: <20120618.202843.1377755046459413169.davem@davemloft.net>
References: <1340075789-6196-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2FSD2r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:28:47 -0400
In-Reply-To: <1340075789-6196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Tue, 19 Jun 2012 05:16:25 +0200

> The patches provide:
> 
> * compilation fixes if CONFIG_NF_CONNTRACK is disabled: I moved all the
>   conntrack code from nfnetlink_queue.c to nfnetlink_queue_ct.c to avoid
>   peppering the entire code with lots of ifdefs. I needed to rename
>   nfnetlink_queue.c to nfnetlink_queue_core.c to get it working with the
>   Makefile tweaks I've added.
> 
> * fix NULL pointer dereference via ctnetlink while trying to change the helper
>   for an existing conntrack entry. I don't find any reasonable use case for
>   changing the helper from one to another in run-time. Thus, now ctnetlink
>   returns -EOPNOTSUPP for this operation.
> 
> * fix possible out-of-bound zeroing of the conntrack extension area due to
>   the helper automatic assignation routine.
> 
> You can pull these changes from:
> 
> git://1984.lsi.us.es/nf-next master

Pulled, thanks.
