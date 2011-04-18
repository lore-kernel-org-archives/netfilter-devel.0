From: Patrick McHardy <kaber@trash.net>
Subject: Re: guided option parser, run 3
Date: Mon, 18 Apr 2011 15:05:38 +0200
Message-ID: <4DAC3722.3040506@trash.net>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1DRNFl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:05:41 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.04.2011 18:13, schrieb Jan Engelhardt:
> The following changes since commit 316ae9d2f1996caea4cf221201accb8c2087a154:
> 
>   Merge branch 'opts' of git://dev.medozas.de/iptables (2011-04-13 13:38:20 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables floating/opts
> 
> Jan Engelhardt (26):
>       libxtables: XTTYPE_MARKMASK32 support
>       libxt_MARK: use guided option parser
>       libxt_CONNMARK: use guided option parser
>       libxtables: XTTYPE_UINT64 support
>       libxt_quota: use guided option parser
>       libxtables: linked-list name<->id map
>       libxt_devgroup: use guided option parser
>       libipt_realm: use guided option parser
>       libxtables: XTTYPE_UINT16RC support
>       libxt_length: use guided option parser
>       libxt_tcpmss: use guided option parser
>       libxtables: XTTYPE_UINT8RC support
>       libxtables: XTTYPE_UINT64RC support
>       libxt_connbytes: use guided option parser
>       libxtables: XTTYPE_UINT16 support
>       libxt_CT: use guided option parser
>       libxt_NFQUEUE: use guided option parser
>       libxt_TCPMSS: use guided option parser
>       libxtables: pass struct xt_entry_{match,target} to x6 parser
>       libxt_string: use guided option parser
>       libxtables: XTTYPE_SYSLOGLEVEL support
>       libip[6]t_LOG: use guided option parser
>       libxtables: XTTYPE_ONEHOST support
>       libxtables: XTTYPE_PORT support
>       libxt_TPROXY: use guided option parser
>       libipt_ULOG: use guided option parser

Pulled, thanks Jan.
