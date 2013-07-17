From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables - PATCH 6/9] nft: Print chains in right order
 when listing rules
Date: Wed, 17 Jul 2013 10:07:36 +0300
Message-ID: <51E642B8.10107@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1373978333-17427-7-git-send-email-tomasz.bursztyka@linux.intel.com> <20130716205743.GA17208@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11845 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3GQHHz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:07:55 -0400
In-Reply-To: <20130716205743.GA17208@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I have just checked this. The order is fine except by the nat table,
> that one has been corrected it here:
>
> http://git.netfilter.org/iptables-nftables/commit/?id=990b5aec1df02450545b57b94d3c960d9b7b1188
>
> However, if the xtables.conf file is used, the order was reversed so I
> could reproduce exactly the same output that you posted here.
>
> I have fixed that by fixing the semantically of nft_*_list_add in
> libnftables to prepend, instead of appending. Now we have
> nft_*_list_add_tail, I have adapted iptables-nftables to use add_tail
> when needed:
>
> http://git.netfilter.org/iptables-nftables/commit/?id=5e6ed2aae9e4a8ec0a340036f485c2567635eca9
>
> Those should be enough to resolve this issue.

If you think it's sufficient to ensure right chain ordering then ok, as 
long as users don't mess up with conf/save files.
I did not liked much the for loop on builtin chains anyway.

Tomasz
