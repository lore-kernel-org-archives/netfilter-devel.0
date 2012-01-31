From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Alter TCP packet not work fine with netfilter hook
Date: Tue, 31 Jan 2012 17:03:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201311703080.5243@frira.zrqbmnf.qr>
References: <CANopevWckbSuu2jys5BjCLLU6TF0FHZNgK8SgbY2PAEpRuxQmw@mail.gmail.com> <CANopevXXq8Moz2mM0+EExapCAv+va-Q6qv7=UMXpaQZV_AF3og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Cao Xuan Sang <sangkao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55855 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2AaQEB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:04:01 -0500
In-Reply-To: <CANopevXXq8Moz2mM0+EExapCAv+va-Q6qv7=UMXpaQZV_AF3og@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-01-31 05:46, Cao Xuan Sang wrote:

>> Hi netfilter family,
>> I'm a newbie to netfilter.
>> I have just developt a crypto module using netfilter hook.
>> In this module :
>> SENDER : IP payload will be encrypted at POST ROUTING hook
>> RECEIVE : IP payload wil be decrypted at PRE ROUTING hook.
>>
>> The module work fine with ICMP & UDP but it NOT work fine with TCP: 2 machine still receive packet at hook but application not communicate together.
>>
>> I don't know whether any mystery in netfilter or linux network kernel at here?
>>
>> Thanks :)
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in

I just wonder what's up with people that hit reply and send without 
writing anything (or even adding to cc).
