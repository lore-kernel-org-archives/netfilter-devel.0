From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables
Date: Tue, 05 May 2009 15:38:08 +0200
Message-ID: <4A004140.30805@trash.net>
References: <49F56742.7080309@gmx.de> <alpine.LSU.2.00.0904292232050.9772@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Manu <manuprivat@gmx.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEENiJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:38:09 -0400
In-Reply-To: <alpine.LSU.2.00.0904292232050.9772@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-04-27 10:05, Manu wrote:
>> #iptables -nvL -t mangle
>>
>> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>> pkts bytes target     prot opt in     out     source               destination
>> insmod: ip_tables.ko: no module by that name found
>> modprobe: failed to load module ip_tables
>> insmod: ip_tables.ko: no module by that name found
>> modprobe: failed to load module ip_tables
>> insmod: ip_tables.ko: no module by that name found
>> modprobe: failed to load module ip_tables
>> insmod: ip_tables.ko: no module by that name found
>> modprobe: failed to load module ip_tables
>>   0     0 MARK       all  --  *      *       10.0.20.2            0.0.0.0/0
>> MARK set 0x14
>>
>>
>> My kernel is built with every point of iptables stuff included, not as module.
> 
> I cannot reproduce this :/

Well, the message obviously originates from modprobe. So it seems
to ignore the "-q" option set by iptables.

Manu, please provide a strace -f of the iptables execution and
your module-init-tools version.

