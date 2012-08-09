From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/7] extensions: add IPv6 MASQUERADE extension
Date: Thu, 9 Aug 2012 23:26:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208092325410.10514@frira.zrqbmnf.qr>
References: <1344543073-11660-1-git-send-email-kaber@trash.net> <1344543073-11660-3-git-send-email-kaber@trash.net> <alpine.LNX.2.01.1208092310250.10514@frira.zrqbmnf.qr> <Pine.GSO.4.63.1208092319250.25804@stinky-local.trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:35708 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2HIV0N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:26:13 -0400
In-Reply-To: <Pine.GSO.4.63.1208092319250.25804@stinky-local.trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-08-09 23:22, Patrick McHardy wrote:
>>
>> Is it perhaps feasible to rename libipt_DNAT.c to libxt_DNAT.c
>> and thus have the v4 and v6 parts in the same file? In userspace
>> we do not have to fear depending on ipv6.ko like for kernel modules.
>
> I did that at first, but they use different structures
> (nf_nat_ipv4_multi_range_compat vs. nf_nat_range), so there's actually
> almost no code which can be shared.

Will we be able to use nf_nat_range for IPv4 NAT parts
in the future as well?
