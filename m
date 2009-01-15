From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_statistic.c - the statistic match
Date: Thu, 15 Jan 2009 11:45:58 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901151143480.400@fbirervta.pbzchgretzou.qr>
References: <4967CDCB.3080306@astrocorp.com>  <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>  <496B7F66.40900@astrocorp.com> <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bryan Duff <bduff@astrocorp.com>, netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52290 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZAOKqA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:46:00 -0500
In-Reply-To: <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-15 11:37, James King wrote:
>>>> //snip - iptables -L
>>>> 978189 1210792980 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x1
>>>> 2182885 2704995300 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x2
>>>> 2289382 2862482240 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x3
>>>> 1417708 1807169776 MARK       all  --  ethX   *       10.10.10.0/24
>>>>  10.10.11.0/24    MARK set 0x1
>>>> 1417708 1807169776 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>>  10.10.11.0/24    MARK match 0x1
>> //end snip
>
>I'm a bit curious about this.  I thought it was only possible to use
>the MARK target in mangle, but you seem to be listing the filter
>table.  I notice that mark_tg_reg[] revision 2 doesn't limit the table
>to mangle like r0 and r1 do (anyone know if this a bug, or is r2
>intended to be available everywhere?)

Just posted moments ago:
http://marc.info/?l=netfilter-devel&m=123200677329507&w=2

>If you're using iptables to commit these rules individually (as your
>first message implies) and the system is under traffic already, it's
>easy for them to get out of sync because each nth rule tracks its own
>state individually and MARK is non-terminating.

And iptables -Z should take care of the counters if rules are added
one-by-one. Also noteworthy is that when iptables is run, the
ruleset (including counters) is downloaded from the kernel, and
later uploaded again - possible setting counters backwards.
(I do no think there are any workarounds to that in the kernel,
at least I have not seen any.)
But at least all of the counters are set to where they were.
