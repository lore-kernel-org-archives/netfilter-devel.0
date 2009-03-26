From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Thu, 26 Mar 2009 11:26:47 +0100
Message-ID: <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
	 <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>
	 <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>
	 <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
	 <49CA8A6B.1020603@gmail.com>
	 <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>
	 <49CA8C5A.1030908@gmail.com>
	 <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
	 <49CA9B8B.7080605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51659 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZCZK0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:26:51 -0400
Received: by bwz17 with SMTP id 17so455341bwz.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 03:26:48 -0700 (PDT)
In-Reply-To: <49CA9B8B.7080605@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> However, I have noticed a similar problem when using my module on
>>>>> incoming
>>>>> packets in PREROUTING (on the multihomed receiver), the IP adress is
>>>>> changed
>>>>> (accoring to my dmesg-output) but then they are not heard from again.
>>>>>
>>>>
>>>> Probably dropped due to L3 or L4 checksum mismatches. While we try to
>>>> change the checksum, I have not verified it for all cases.
>>>>
>>>>
>>>
>>> Hm, I am noe sure. I recalculate the checksum (using csum_replace4 for l3
>>> and
>>> inet....replace4 for l4) after modifying the destination IP, and when
>>> used with
>>> OUTPUT the checksum is correct. Since tcpdump/Wireshark outputs the
>>> packets
>>> before they are modified I haven't been able to verify this though.
>>>

Turned out that it was the checksums. They were calculated correctly,
but since I processed packets on input, tcp_hdr and udp_hdr of course
returned invalid pointers. My code is now more or less RAWNAT, so if
it is of interest to anybody else I will merge them and make it
available.

-Kristian
