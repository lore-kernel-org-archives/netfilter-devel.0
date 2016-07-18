From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] meta: add random expression key
Date: Mon, 18 Jul 2016 21:34:21 +0200
Message-ID: <20160718193421.GA4275@salvia>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58103 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbcGRTe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 15:34:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 40F6C168385
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:34:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3339052D92
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:34:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 309EE52D92
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2016 21:34:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467704135-9154-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 09:35:33AM +0200, Florian Westphal wrote:
> meta random fills a 32bit register with a pseudo-random number.
> 
> For instance one can now use
> 
> meta random <= 2147483647
> 
> ... to match every 2nd packet, on average.
> 
> A followup patch will add a short-hand version ('probability 0.5') so
> that users do not have to deal with details.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Please, apply this patch.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

We can later on revisit the probability scaling, so keep 2/3 and 3/3
back by now.

Thanks.
