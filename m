From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_statistic.c - the statistic match
Date: Sat, 10 Jan 2009 04:38:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>
References: <4967CDCB.3080306@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38860 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZAJDid (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2009 22:38:33 -0500
In-Reply-To: <4967CDCB.3080306@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-09 23:20, Bryan Duff wrote:

> ... gets out of sync in nth mode.  The count seems to be off somehow.  At some
> point the count is off - in my case I have 3 rules that are consecutive:
>
> //snip - iptables rules
> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m
> statistic --mode nth --every 3 --packet 0 -j MARK --set-mark 1
> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m
> statistic --mode nth --every 3 --packet 1 -j MARK --set-mark 2
> iptables -t
> mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m statistic
> --mode nth --every 3 --packet 2 -j MARK --set-mark 3
> //end snip
>
> Now when I accept those mark values, the packet counts which should be almost
> equal are off by large numbers (hundreds of thousands):

Works for me..

# iptables-save -c
[11253:5051887] -A PREROUTING -m statistic --mode nth --every 3 [--packet 0]
[11254:5117265] -A PREROUTING -m statistic --mode nth --every 3 --packet 1 

> //snip - iptables -L
> 978189 1210792980 ACCEPT     all  --  ethX   *       10.10.10.0/24
> 10.10.11.0/24    MARK match 0x1
> 2182885 2704995300 ACCEPT     all  --  ethX   *       10.10.10.0/24
> 10.10.11.0/24    MARK match 0x2
> 2289382 2862482240 ACCEPT     all  --  ethX   *       10.10.10.0/24
> 10.10.11.0/24    MARK match 0x3

These do not seem to be the same rules you posted above.
Where do all the mark matches come from?

> 1417708 1807169776 MARK       all  --  ethX   *       10.10.10.0/24
> 10.10.11.0/24    MARK set 0x1
> 1417708 1807169776 ACCEPT     all  --  ethX   *       10.10.10.0/24
> 10.10.11.0/24    MARK match 0x1
> //end snip
