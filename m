From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables: various fixes for handling multiple src/dst addresses
Date: Tue, 22 Feb 2011 04:48:45 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102220445190.29995@obet.zrqbmnf.qr>
References: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Wes Campaigne <westacular@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39504 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1BVDsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:48:47 -0500
In-Reply-To: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-02-22 01:10, Wes Campaigne wrote:

>Hi! I've been working on enabling robust IPv6 support in the TomatoUSB router firmware. In the process, I found and fixed a few old iptables bugs, mostly related to lookups and the handling of multiple addresses. Please review!
>
>NOTE: TomatoUSB is actually still using an old 1.3.8 branch of iptables, and analogous versions of these patches against that version have been commited on the TomatoUSB repo at repo.or.cz/w/tomato.git tomato-RT
>
>===
>Wes Campaigne (4):
>  xtables: use *all* IPv6 addresses resolved from a hostname
>  xtables: fix excessive memory allocation in host_to_ipaddr
>  xtables: fix the broken detection/removal of redundant addresses
>  xtables: use the correct loop count when applying masks to addresses

The last one has already beek taken care of (cf.
http://bugs.debian.org/611990), I am checking the rest as the
lines enlighten me :)

