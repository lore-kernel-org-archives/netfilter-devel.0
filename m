From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 22:00:59 +0100
Message-ID: <49CA9B8B.7080605@gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr> <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com> <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr> <49CA8A6B.1020603@gmail.com> <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr> <49CA8C5A.1030908@gmail.com> <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44254 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZCYU4u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:56:50 -0400
Received: by ewy9 with SMTP id 9so267439ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 13:56:47 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt skrev:
> On Wednesday 2009-03-25 20:56, Kristian Evensen wrote:
>
>   
>> Jan Engelhardt skrev:
>>     
>>> On Wednesday 2009-03-25 20:47, Kristian Evensen wrote:
>>>  
>>>       
>>>> However, I have noticed a similar problem when using my module on incoming
>>>> packets in PREROUTING (on the multihomed receiver), the IP adress is changed
>>>> (accoring to my dmesg-output) but then they are not heard from again.
>>>>    
>>>>         
>>> Probably dropped due to L3 or L4 checksum mismatches. While we try to
>>> change the checksum, I have not verified it for all cases.
>>>
>>>  
>>>       
>> Hm, I am noe sure. I recalculate the checksum (using csum_replace4 for l3 and
>> inet....replace4 for l4) after modifying the destination IP, and when used with
>> OUTPUT the checksum is correct. Since tcpdump/Wireshark outputs the packets
>> before they are modified I haven't been able to verify this though.
>>     
>
> You can use hexdump in the xtables module, or any other form, to
> dump the checksum.
>   
I had completely forgot that, thank you. However, tcpdump tells me that 
the checksum is ok, but I will look into it and simply compare a packet 
that has not been redirected with one that has. Thank you.

-Kristian
