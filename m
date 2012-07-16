From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  [PATCH 2/2] extensions: add HMARK target
Date: Mon, 16 Jul 2012 16:01:59 +0200 (CEST)
Message-ID: <tqndgm6.3fe615503b90568ff6a9ec2aa89d2c7e@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:49988 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2GPOCD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:02:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>[...]
>> >I'll be OK to make --hmark-offset mandatory, BTW.
>>
>> Well,  if people use it to other things than PBR it will be bad to have it mandatory
>> so I think we leave it as it is.
>
>Sorry, I missed this mail and pushed this into master. Already made it
>mandatory. Send me a patch if you want to relax this.  I'll apply it.

OK I'll add that to next patch.

>> I don't like is that MODE_L3 is gone
>> L3 can be substituted by using --hamrk-tuple src, dst. so that might be OK
>> but there is no flag set. (causing a lot of extra cpu cycles)
>
>This saves cycles for some specific case, but at the cost of adding
>some branch misprediction in other case (ie. more cycles in other
>cases). If we aim to genericity, we have to remove it.

I think there is a simple solution for it, I will send a separate patch for that.

>BTW, I'd like to see some follow-up patch to support ICMP. We can just
>generate the hash mark it using the src,dst,proto parts. That should
>be easy.

Yes,  especially to match icmp errors.

>> All masks have gone from set to  zero, (due to hmark-tuple ?)
>> If it's more clear or not , I don't know  but the man page needs to be updated
>>  --hmark-tuple ct alone doesn't do much.
>
>You're right, I fixed this in a follow-up patch now in master.
>
>> iptables \-t mangle \-A PREROUTING \-m state \-\-state NEW
>> - \-j HMARK \-\-hmark-tuple ct \-\-hmark-offset 10000 \-\-hmark\-mod 10
>> change to
>> + \-j HMARK \-\-hmark-tuple ct,src,dst \-\-hmark-offset 10000 \-\-hmark\-mod 10
>> \-\-hmark\-rnd 0xfeedcafe
>> 
>> Some faults found during my first sanity check.
>> (I have not run any real tests so far, just some manual command  tests
>> Due to the new behaviour and syntax the test suite needs some update)
>
>I've applied this patch below. Please, add description next time.

I was not meant to be a "patch" just an indication what I've found at a first look ...

The next change will be sent as formal patch :-)

/Hans

