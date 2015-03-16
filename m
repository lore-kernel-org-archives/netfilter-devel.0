From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next v2] netfilter: bridge: query conntrack about skb
 dnat
Date: Mon, 16 Mar 2015 23:51:18 +0100
Message-ID: <20150316225118.GA4435@salvia>
References: <1425960499-8997-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbbCPWr1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 18:47:27 -0400
Content-Disposition: inline
In-Reply-To: <1425960499-8997-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 05:08:19AM +0100, Florian Westphal wrote:
> ask conntrack instead of storing ipv4 address in nf_bridge_info->data.
> 
> Ths avoids the need to use ->data during NF_PRE_ROUTING.
> Only two functions that need ->data remain.
> 
> These will be addressed in followup patches.

Applied, thanks.
