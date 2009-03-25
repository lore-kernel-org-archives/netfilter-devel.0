From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 20:47:55 +0100
Message-ID: <49CA8A6B.1020603@gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr> <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com> <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37798 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbZCYTnq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:43:46 -0400
Received: by ewy9 with SMTP id 9so234922ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 12:43:42 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>>> My theory is that the original MAC-address is somehow added to the SKB
>>>> before it reaches the output-part of the RAW-table (which is where I
>>>> hook in),
>>>>         
>>> Routing is done before rawpost, yes, but before the (traditional) raw table.
>>> (it's in skb->dst)
>>>       
>> Ok, I assumed that the MAC-header was added at a lower layer, but that
>> was then wrong? For some reason I have always though skb->dst was the
>> IP-adress, I will look into that field.
>>     
>
> skb->dst contains the pointer to the neighbor (simply put), and a 
> neighbor is (also simplified) what you see in `ip neigh`, i.e. MAC 
>
>   
I can now confirm that this works, doing another lookup and updating the 
dst solved the problem and the MAC-header is now correct. I will clean 
up the code and then patch it into RAWNAT or something similar tomorrow, 
if it is of any interest.

However, I have noticed a similar problem when using my module on 
incoming packets in PREROUTING (on the multihomed receiver), the IP 
adress is changed (accoring to my dmesg-output) but then they are not 
heard from again. I have not debugged this properly, but if anyone has 
experienced something similar, feel free :) Can it be caused by the 
wrong MAC-header (changing dst does not work on input on my machine, the 
two interfaces are not aware of eachother's MAC address) being refused 
by some part of the kernel? As always, it for some reasong works when 
using DNAT, but I have not been able to figure out why :)

-Kristian
