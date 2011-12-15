From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for
 iptables
Date: Thu, 15 Dec 2011 22:01:16 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112152200410.2122@frira.zrqbmnf.qr>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com> <20111214133010.GA3155@1984> <CABa6K_HLc2w5K4taYmrNfhdXTPZsvE=OmdQtNnYBm32Erw8yBA@mail.gmail.com>
 <alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr> <871us5bn3t.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34217 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab1LOVBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:01:18 -0500
In-Reply-To: <871us5bn3t.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-12-15 21:23, Ferenc Wagner wrote:

>Jan Engelhardt <jengelh@medozas.de> writes:
>
>> On Wednesday 2011-12-14 15:52, Changli Gao wrote:
>>
>>> On Wed, Dec 14, 2011 at 9:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>
>>>> On Wed, Dec 14, 2011 at 09:12:52PM +0800, Changli Gao wrote:
>>>>>
>>>>> Why not use the counters of iptables instead?
>>>>>
>>>>> iptables-save -c
>>>>
>>>> If you want to obtain the sum of the counters that match some criteria,
>>>> you have to iterate over the whole list of existing rules, look for
>>>> matchings and update the counters.
>>>
>>> As I said in another thread, you can redirect the traffic to a
>>> separated chain, and use the counters of that chain.
>>
>> UDCs (user defined chains) don't have counters, though.
>
>So put an empty rule into them.  The ip_ plugin of Munin uses this
>technique for quite some time.
>
>>>> Moreover, if you have a large rule-set, polling periodically
>>>> iptables-save -c can be expensive.
>>>
>>> I got it. Thanks. Maybe we can index the entries in the kernel, and
>>> add a new interface to get the counters of a special entry with a
>>> entry ID.
>>
>> Relying on the rule number is a terrible idea (just like 
>> iptables-save|head -n5|tail -n1 would be). Unique persistend IDs are 
>> unfavorable as well; names, as used with xt_quota2/xt_NFACCT can be 
>> remembered much more easily.
>
>Rule names could serve this, couldn't they?  And rules can be identified
>by -m comment if batch processing is required.

Then you can just as well use nfacct's name.
