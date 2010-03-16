From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/10] netfilter: xtables: merge xt_NOTRACK into xt_CT
Date: Tue, 16 Mar 2010 18:46:18 +0100
Message-ID: <4B9FC3EA.2030501@trash.net>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de> <1268703135-2622-7-git-send-email-jengelh@medozas.de> <4B9FB972.7010207@trash.net> <alpine.LSU.2.01.1003161814340.25891@obet.zrqbmnf.qr> <4B9FBD75.3070205@trash.net> <alpine.LSU.2.01.1003161828370.19522@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938040Ab0CPRqU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:46:20 -0400
In-Reply-To: <alpine.LSU.2.01.1003161828370.19522@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The following changes since commit 3a5b27bf6f29574d667230c7e76e4b83fe3014e0:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (10):
>       netfilter: xt_CT: par->family is an nfproto
>       netfilter: xt_NFQUEUE: consolidate v4/v6 targets into one
>       netfilter: xtables: add comment markers to Xtables Kconfig
>       netfilter: xtables: merge xt_MARK into xt_mark
>       netfilter: xtables: merge xt_CONNMARK into xt_connmark
>  *    netfilter: xtables: schedule xt_NOTRACK for removal
>       netfilter: update my email address
>       netfilter: ebt_ip6: add principal maintainer in a MODULE_AUTHOR tag
>       netfilter: xt_recent: update description
>       netfilter: xt_recent: remove old proc directory
> 

Pulled, thanks Jan.
