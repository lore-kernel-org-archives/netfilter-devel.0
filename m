From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Are concurrent calls to tc action ipt safe?
Date: Mon, 19 Jul 2010 18:44:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007191841500.19191@obet.zrqbmnf.qr>
References: <201007191623.40423.lists@egidy.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: "Gerd v. Egidy" <lists@egidy.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55290 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936420Ab0GSQoe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jul 2010 12:44:34 -0400
In-Reply-To: <201007191623.40423.lists@egidy.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-07-19 16:23, Gerd v. Egidy wrote:
>AFAIK, current iptables has a short race condition when two rules within the 
>same table are changed at once.
>
>E.g. when two users simultaneously call something like this
>iptables -t filter -A INPUT -s 192.168.1.1 -j MARK --set-mark 1
>and
>iptables -t filter -A INPUT -s 192.168.1.2 -j MARK --set-mark 2
>one of these entries can get lost.

There are many serialization techniques possible to serialize iptables 
execution.

>tc filter add dev eth0 parent ffff: protocol ip prio 1 u32  \
>match ip src 192.168.1.1 \
>action ipt -j MARK --set-mark 1
>
>Since this call uses the xtables targets I'm currently not sure if the same 
>problem regarding concurrent changes exists or not. Can anyone tell me if 
>concurrent calls like this are safe?

This target invocation is not in any table, thus there is no race 
condition.

