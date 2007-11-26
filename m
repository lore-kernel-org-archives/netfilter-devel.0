From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix make/compile error for iptables-1.4.0rc1
Date: Mon, 26 Nov 2007 07:23:28 +0100
Message-ID: <474A6660.2030109@trash.net>
References: <1195828201.3866.20.camel@localhost.localdomain>	<1195834612.3866.42.camel@localhost.localdomain>	<47499137.3060709@trash.net> <200711260555.lAQ5tXS0025231@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jdb@comx.dk, yasuyuki@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46608 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXKZGYR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 01:24:17 -0500
In-Reply-To: <200711260555.lAQ5tXS0025231@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 25 Nov 2007 16:13:59 +0100
> 
>> Applied, but I stripped the #ifdef __KERNEL__ sections first.
>> Thanks Jesper.
> 
> Thanks Jesper and Patrick. That looks fine to me.
> 
> XT_SO_GET_REVISION_{MATCH,TARGET} in 2.6.18 was removed because of
> conflicts on {get,set}sockopt number of IPv6 socket. I.e. ip_tables.h
> you used on build included bug.
> 
> iptables.c only uses IPT_SO_GET_REVISION_* and they are defined in local
> header include/iptables.h. I suspects that
> /usr/include/linux/netfilter_ipv4/ip_tables.h re-defined
> IPT_SO_GET_REVISION_* with XT_SO_GET_REVISION_* on your environment.


Thanks for double-checking the patch.

> P.S. sorry for late reply. I was very busy for other work this several
> months but I will be able to contribute to netfilter again from next month.


Sounds great :)
