From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset and iptables problem.
Date: Thu, 8 Jan 2009 16:29:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901081621490.24994@fbirervta.pbzchgretzou.qr>
References: <49660570.70501@metu.edu.tr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Husnu Demir <hdemir@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34641 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZAHP3k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:29:40 -0500
In-Reply-To: <49660570.70501@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-08 14:53, Husnu Demir wrote:

>Hi,
>
>I have problems with iptables and ipset. Is new iptables compatible with ipset?
>
>The details are below?

Well are they?

> uname -a
>Linux hai 2.6.28 #2 SMP Wed Jan 7 13:15:14 EET 2009 x86_64 GNU/Linux
> ipset -V
>ipset v2.4.5 Protocol version 2.

> iptables -I FORWARD -m set --set yeni src -j ACCEPT
> hai kernel: Oops: 0000 [#8] SMP
> hai kernel: last sysfs file: /sys/devices/virtual/net/lo/operstate
> hai kernel: Stack:
> hai kernel: ffff88023ded0908 0000000000000070 ffff88023ded0898 ffff880223e31540
> hai kernel: ffff88023ded0800 ffffffffa00c4cc3 ffff88023ded090a ffffffffa00c4f64
> hai kernel: Call Trace:
> hai kernel: [<ffffffffa00ba280>] xt_check_match+0x12a/0x143 [x_tables]

Compiling the unmodified 2.4.5 with 2.6.28 should give compiler warnings,
and they should not be ignored.

A modified version of ipset 2.4.5 ships with Xtables-addons 1.7 and is 
runnable with 2.6.28.
