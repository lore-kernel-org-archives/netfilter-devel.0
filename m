From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6]: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insersion
Date: Wed, 24 Sep 2008 17:29:43 +0200
Message-ID: <48DA5CE7.9040407@trash.net>
References: <200809080613.m886DnGY021233@toshiba.co.jp>	<48C61D88.6050703@trash.net> <200809091019.m89AJniP013456@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXP3q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:29:46 -0400
In-Reply-To: <200809091019.m89AJniP013456@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 09 Sep 2008 08:54:00 +0200
> 
>> Yasuyuki KOZAKAI wrote:
>>> Hi Patrick,
>>>
>>> Please apply the following patch. The option IP6T_OPTS_NSTRICT causes to
>>> ignore rules for options in HBH/DST header.
>>>
>>> I think this issue affects few users. Because fortunately (?) man page and
>>> 'ip6tables -m hbh --help' does not show --hbh-not-strict option, and
>>> 'ip6tables ... --hbh-not-strict' does not work due to incorrect has_arg
>>> value in userland libip6t_hbh.c ;)
>>>
>>> I will implement not-strict mode, so the patch leaves the definition of
>>> IP6T_OPTS_NSTRICT. The strict mode is too strict (the specified options
>>> have to be included in order in HBH/DST header) and would be useless
>>> in most senarios.
>> Since my knowledge of this quite limited - is this fix important
>> enough so it should go in 2.6.27, or is queuing it for 2.6.28 OK
>> too?
> 
> Actually I am torn between them. I think this is security issue, like that
> 'iptables -p tcp -j DROP' does not drop TCP packets.
> But no ip6tables user meet this issue because of has_arg bug.
> 
> I prefer 2.6.27 so that I don't need to fear rare case in several months :)

Applied, thanks, and sorry for the delay.
