From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Netfilter fixes for net
Date: Mon, 09 Dec 2013 20:43:59 -0500 (EST)
Message-ID: <20131209.204359.870819413394556150.davem@davemloft.net>
References: <1386458010-4615-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LJBoB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:44:01 -0500
In-Reply-To: <1386458010-4615-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun,  8 Dec 2013 00:13:27 +0100

> The following patchset contains three Netfilter fixes for your net tree,
> they are:
> 
> * fix incorrect comparison in the new netnet hash ipset type, from
>   Dave Jones.
> 
> * fix splat in hashlimit due to missing removal of the content of its
>   proc entry in netnamespaces, from Sergey Popovich.
> 
> * fix missing rule flushing operation by table in nf_tables. Table
>   flushing was already discussed back in October but this got lost and
>   no patch has hit the tree to address this issue so far, from me.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master

Pulled, thanks Pablo.
