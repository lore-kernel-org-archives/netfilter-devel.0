From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sat, 16 Jul 2016 12:49:50 +0200
Message-ID: <20160716104950.GC6123@breakpoint.cc>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49101 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbcGPKuH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 06:50:07 -0400
Content-Disposition: inline
In-Reply-To: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
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
>   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> 
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>

Looks good, thanks!

Acked-by: Florian Westphal <fw@strlen.de>
