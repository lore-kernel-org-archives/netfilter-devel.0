From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables ruleset not working when compiling on 	fedora6,7,8/centos
 5/redhat 5
Date: Wed, 01 Jul 2009 11:56:20 +0200
Message-ID: <4A4B32C4.8050800@trash.net>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>	 <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>	 <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>	 <4A48D6AD.4010005@trash.net>	 <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>	 <4A48E14A.3060708@trash.net>	 <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com> <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Nishit Shah <nsshah.82@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53639 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZGAJ4Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:56:25 -0400
In-Reply-To: <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> On Mon, Jun 29, 2009 at 9:48 PM, Nishit Shah<nsshah.82@gmail.com> wrote:
>> On Mon, Jun 29, 2009 at 9:14 PM, Patrick McHardy<kaber@trash.net> wrote:
>>> Ah, I remember, we had some breakage with of the ARPT codes with the
>>> introduction of x_tables in 2.6.16. Please try to figure out the
>>> difference of those values between working and non-working state
>>> (ARPT_CONTINUE, ARPT_RETURN etc.)
>>>
>> Bingo !!!
>>
>> It is due to the value of ARPT_RETURN. ARPT_RETURN defined in
>> arptables-v0.0.3-3 is
>>
>> ./include/linux/netfilter_arp/arp_tables.h:#define ARPT_RETURN
>> (-NF_MAX_VERDICT - 1)
>>
>> and value of NF_MAX_VERDICT is different on machine running with gcc
>> 2.96/glibc 2.2.4 and above all machines.
>>
>> value of NF_MAX_VERDICT on machine running gcc 2.96 and glibc 2.2.4,
>>
>>        /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_REPEAT
>>
>> and same file on all above machines,
>>
>>        /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_STOP
>>
>> Thanks Patrick :)
>>
>> Rgds,
>> Nishit Shah.
>>
> 
> I am adding the patch for the same.

Please send this to Bart (CCed), who is maintaining arptables.

