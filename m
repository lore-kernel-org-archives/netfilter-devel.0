From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: bridge: fix routing of bridge frames
 with call-iptables=1
Date: Wed, 16 Sep 2015 16:57:03 +0200
Message-ID: <20150916145703.GA15642@salvia>
References: <1442243187-19855-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux@eikelenboom.it
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35816 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbbIPOuX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 10:50:23 -0400
Content-Disposition: inline
In-Reply-To: <1442243187-19855-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 14, 2015 at 05:06:27PM +0200, Florian Westphal wrote:
> We can't re-use the physoutdev storage area.
> 
> 1.  When using NFQUEUE in PREROUTING, we attempt to bump a bogus
> refcnt since nf_bridge->physoutdev is garbage (ipv4/ipv6 address)
> 
> 2. for same reason, we crash in physdev match in FORWARD or later if
> skb is routed instead of bridged.
> 
> This increases nf_bridge_info to 40 bytes, but we have no other choice.

Applied, thanks.
