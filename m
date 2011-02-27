From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: docs & address parsing
Date: Sun, 27 Feb 2011 16:19:50 +0100
Message-ID: <4D6A6B96.1010504@trash.net>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34941 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1B0PTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:19:51 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.02.2011 02:31, Jan Engelhardt wrote:
> The following changes since commit 094f104af71ca859c7c44406baed401659ad9421:
> 
>   libipt_ECN: set proper option flags (2011-02-19 20:08:29 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (5):
>       doc: mention other possible nf_loggers for TRACE
>       doc: fix odd partial sentence in libipt_TTL
>       libxt_quota: require --quota to be specified
>       doc: rateest options can be optional
>       libxtables: fix memory scribble beyond end of array
> 
> Wes Campaigne (4):
>       libxtables: avoid confusing use of ai_protocol=IPPROTO_IPV6
>       xtables: fix excessive memory allocation in host_to_ipaddr
>       xtables: fix the broken detection/removal of redundant addresses
>       xtables: use all IPv6 addresses resolved from a hostname

Pulled, thanks Jan.
