From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_ct: make byte/packet expr more
 friendly
Date: Tue, 5 Jul 2016 17:31:02 +0200
Message-ID: <20160705153102.GA15293@breakpoint.cc>
References: <1467732180-3938-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56850 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbcGEPb3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 11:31:29 -0400
Content-Disposition: inline
In-Reply-To: <1467732180-3938-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If we want to use ct packets expr, and add a rule like follows:
>   # nft add rule filter input ct packets gt 1 counter
> 
> We will find that no packets will hit it, because
> nf_conntrack_acct is disabled by default. So It will
> not work until we enable it manually via
> "echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct".
> 
> This is not friendly, so like xt_connbytes do, if the user
> want to use ct byte/packet expr, enable nf_conntrack_acct
> automatically.

Good idea, thanks!
