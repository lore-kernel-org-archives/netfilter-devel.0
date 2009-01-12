From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:13:28 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120711210.21692@fbirervta.pbzchgretzou.qr>
References: <496AD8C7.2020208@trash.net> <496AD922.7050909@trash.net> <496ADEDE.9050000@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46447 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZALGNa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:13:30 -0500
In-Reply-To: <496ADEDE.9050000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 07:10, Patrick McHardy wrote:

> Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> I get this with the current iptables -git version:
>>>
>>> Makefile.am:7: `:='-style assignments are not portable
>>> Makefile.am:71: `:='-style assignments are not portable
>>> Makefile.am:72: `:='-style assignments are not portable
>>> Makefile.am:73: `:='-style assignments are not portable
>>> Makefile.am:74: `:='-style assignments are not portable
>>> Makefile.am:75: `:='-style assignments are not portable
>>> Makefile.am:78: `:='-style assignments are not portable
>>> Makefile.am:80: `:='-style assignments are not portable
>>> Makefile.am:97: `%'-style pattern rules are a GNU make extension
>>
>> Additionally compilation aborts with:
>>
>> make[2]: *** No rule to make target
>> `../include/linux/netfilter_ipv4/ipt_DSCP.h', needed by `libipt_ECN.oo'.
>> Stop.
>
> This is resolved by using a fresh clone.

Must have been a really old tree, since no .c file besides
libipt_DSCP.c (long renamed libxt_DSCP.c) ever used ipt_DSCP.h.
