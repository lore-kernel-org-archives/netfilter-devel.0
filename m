From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter fix for net
Date: Tue, 29 Oct 2013 16:54:17 -0400 (EDT)
Message-ID: <20131029.165417.2227248279184824852.davem@davemloft.net>
References: <1383048796-7964-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48539 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3J2UyV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:54:21 -0400
In-Reply-To: <1383048796-7964-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 29 Oct 2013 13:13:15 +0100

> This pull request contains the following netfilter fix:
> 
> * fix --queue-bypass in xt_NFQUEUE revision 3. While adding the
>   revision 3 of this target, the bypass flags were not correctly
>   handled anymore, thus, breaking packet bypassing if no application
>   is listening from userspace, patch from Holger Eitzenberger,
>   reported by Florian Westphal.
> 
> You can pull this change from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master

Pulled, thanks Pablo.
