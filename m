From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 09:16:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010070913480.28056@obet.zrqbmnf.qr>
References: <201010061842.20142.sven-ola@gmx.de> <201010062120.36885.sven-ola@gmx.de> <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz> <201010070837.42018.sven-ola@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven-Ola Tuecke <sven-ola@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60052 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0JGHRB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:17:01 -0400
In-Reply-To: <201010070837.42018.sven-ola@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-10-07 08:37, Sven-Ola Tuecke wrote:
>> > space
>> > reasons. Only 1.75 Mb Flash and 8 Mb RAM.
>> 
>> Are there really working IPv6-enabled 2.4 kernels in use?
>
>Yes. The Broadcom router reference design was adopted by a dozen 
>manufacturers. Besides space limitations, there is a binary-only WLAN driver 
>module that forces the use of Linux-2.4.

1.75 MB sounds like an older model, however, that "linux 2.4 use forced"
statement is bogus for WRT54GL (4MB Flash) since at least openwrt 8.09/Linux
2.6.25.

>As Jan pointed out: copy of the addresses may be stored elsewhere in the form 
>of hash keys. At least, I will place a warning in the docs and check for 
>oopses if conntrack is active. You think about a single rule either in 
>POSTROUTING or PREROUTING. May overcome above conntrack hash prob... Good 
>point - I place it on the TODO.

RAWS/DNAT in Xtables-addons has this solved by using the raw and rawpost tables.
