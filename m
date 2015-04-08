From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/6] netfilter: prepare for skb->nf_bridge
 removal
Date: Wed, 8 Apr 2015 18:47:27 +0200
Message-ID: <20150408164727.GA1638@salvia>
References: <1427977905-9927-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44888 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbbDHQnV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:43:21 -0400
Content-Disposition: inline
In-Reply-To: <1427977905-9927-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 02, 2015 at 02:31:39PM +0200, Florian Westphal wrote:
> This series prepares skb->nf_bridge pointer removal.
> 
> This is a resend without the ip_fragment changes since
> its not clear to me (yet) how to resolve that.
> 
> This also means that this resend doesn't include the skb->nf_bridge
> removal since the 'mtu reduction' in ip_fragment() should
> be made private to bridge netfilter first.

Series applied, thanks Florian.
