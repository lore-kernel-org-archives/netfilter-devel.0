From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] extensions: libxt_connlabel: Add translation to
 nft
Date: Sat, 16 Jul 2016 11:04:39 +0200
Message-ID: <20160716090439.GA6123@breakpoint.cc>
References: <1468649723-13550-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49010 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbcGPJE6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 05:04:58 -0400
Content-Disposition: inline
In-Reply-To: <1468649723-13550-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Add translation for connlabel to nftables.
> For examples:
> 
>   # iptables-translate -A INPUT -m connlabel --label bit40
>   nft add rule ip filter INPUT ct label bit40 counter
> 
>   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
>   nft add rule ip filter INPUT ct label set bit40 ct label != bit40 counter

Should probably be:

... ct label and bit40 != bit40 ...

!= bit40 will be true if bit40 and another bit is set.
