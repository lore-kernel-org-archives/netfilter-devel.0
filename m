From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 20:57:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr> <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com> <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
 <49CA8A6B.1020603@gmail.com> <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr> <49CA8C5A.1030908@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46136 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZCYT5p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:57:45 -0400
In-Reply-To: <49CA8C5A.1030908@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-03-25 20:56, Kristian Evensen wrote:

> Jan Engelhardt skrev:
>> On Wednesday 2009-03-25 20:47, Kristian Evensen wrote:
>>  
>>> However, I have noticed a similar problem when using my module on incoming
>>> packets in PREROUTING (on the multihomed receiver), the IP adress is changed
>>> (accoring to my dmesg-output) but then they are not heard from again.
>>>    
>>
>> Probably dropped due to L3 or L4 checksum mismatches. While we try to
>> change the checksum, I have not verified it for all cases.
>>
>>  
> Hm, I am noe sure. I recalculate the checksum (using csum_replace4 for l3 and
> inet....replace4 for l4) after modifying the destination IP, and when used with
> OUTPUT the checksum is correct. Since tcpdump/Wireshark outputs the packets
> before they are modified I haven't been able to verify this though.

You can use hexdump in the xtables module, or any other form, to
dump the checksum.
