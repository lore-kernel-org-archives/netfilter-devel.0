From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 20:56:10 +0100
Message-ID: <49CA8C5A.1030908@gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr> <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com> <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr> <49CA8A6B.1020603@gmail.com> <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37530 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbZCYTwA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:52:00 -0400
Received: by mail-ew0-f165.google.com with SMTP id 9so238269ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 12:51:58 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt skrev:
> On Wednesday 2009-03-25 20:47, Kristian Evensen wrote:
>   
>> However, I have noticed a similar problem when using my module on incoming
>> packets in PREROUTING (on the multihomed receiver), the IP adress is changed
>> (accoring to my dmesg-output) but then they are not heard from again.
>>     
>
> Probably dropped due to L3 or L4 checksum mismatches. While we try to
> change the checksum, I have not verified it for all cases.
>
>   
Hm, I am noe sure. I recalculate the checksum (using csum_replace4 for 
l3 and inet....replace4 for l4) after modifying the destination IP, and 
when used with OUTPUT the checksum is correct. Since tcpdump/Wireshark 
outputs the packets before they are modified I haven't been able to 
verify this though.

-Kristian
