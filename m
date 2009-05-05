From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables
Date: Tue, 5 May 2009 21:26:41 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905052125240.22475@fbirervta.pbzchgretzou.qr>
References: <49F56742.7080309@gmx.de> <alpine.LSU.2.00.0904292232050.9772@fbirervta.pbzchgretzou.qr> <4A004140.30805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Manu <manuprivat@gmx.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58644 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZEET0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 15:26:42 -0400
In-Reply-To: <4A004140.30805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-05-05 15:38, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Monday 2009-04-27 10:05, Manu wrote:
>>> #iptables -nvL -t mangle
>>>
>>> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>>> pkts bytes target     prot opt in     out     source
>>> destination
>>> insmod: ip_tables.ko: no module by that name found
>>> modprobe: failed to load module ip_tables
>>>  0     0 MARK       all  --  *      *       10.0.20.2            0.0.0.0/0
>>> MARK set 0x14
>>>
>>> My kernel is built with every point of iptables stuff included, not as
>>> module.
>>
>> I cannot reproduce this :/
>
> Well, the message obviously originates from modprobe. So it seems
> to ignore the "-q" option set by iptables.

Now that you mention that, perhaps it's an incomplete modprobe
copy in busybox?
