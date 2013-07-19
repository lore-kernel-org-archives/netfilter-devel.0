From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables - PATCH] nft: A non valid if index should
 not be handled
Date: Fri, 19 Jul 2013 16:36:24 +0300
Message-ID: <51E940D8.4090402@linux.intel.com>
References: <1374236914-14401-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20130719124153.GA30763@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45675 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759827Ab3GSNgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:36:37 -0400
In-Reply-To: <20130719124153.GA30763@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> We have to convert iptables-nftables to use NFT_META_IIFNAME instead
> of NFT_META_IIF to make it behave like iptables. This was somewhere in
> my list of pending things.
>
> Would you have a look at that?

Sure.

Tomaz
