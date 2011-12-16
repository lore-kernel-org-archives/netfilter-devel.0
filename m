From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Fri, 16 Dec 2011 16:25:54 +0100
Message-ID: <87ty504jy5.fsf@tac.ki.iif.hu>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	<CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
	<20111214133010.GA3155@1984>
	<CABa6K_HLc2w5K4taYmrNfhdXTPZsvE=OmdQtNnYBm32Erw8yBA@mail.gmail.com>
	<alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr>
	<871us5bn3t.fsf@tac.ki.iif.hu>
	<alpine.LNX.2.01.1112152200410.2122@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Changli Gao <xiaosuo@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:51580 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010Ab1LPP0V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:26:21 -0500
In-Reply-To: <alpine.LNX.2.01.1112152200410.2122@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Thu, 15 Dec 2011 22:01:16 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:

> On Thursday 2011-12-15 21:23, Ferenc Wagner wrote:
>
>> Jan Engelhardt <jengelh@medozas.de> writes:
>>
>>> On Wednesday 2011-12-14 15:52, Changli Gao wrote:
>>>
>>>> On Wed, Dec 14, 2011 at 9:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>>
>>>>> On Wed, Dec 14, 2011 at 09:12:52PM +0800, Changli Gao wrote:
>>>>>>
>>>>>> Why not use the counters of iptables instead?
>>>>>>
>>>>>> iptables-save -c
>>>>>
>>>>> If you want to obtain the sum of the counters that match some criteria,
>>>>> you have to iterate over the whole list of existing rules, look for
>>>>> matchings and update the counters.
>>>>
>>>> As I said in another thread, you can redirect the traffic to a
>>>> separated chain, and use the counters of that chain.
>>>
>>> UDCs (user defined chains) don't have counters, though.
>>
>> So put an empty rule into them.  The ip_ plugin of Munin uses this
>> technique for quite some time.
>>
>>>>> Moreover, if you have a large rule-set, polling periodically
>>>>> iptables-save -c can be expensive.
>>>>
>>>> I got it. Thanks. Maybe we can index the entries in the kernel, and
>>>> add a new interface to get the counters of a special entry with a
>>>> entry ID.
>>>
>>> Relying on the rule number is a terrible idea (just like 
>>> iptables-save|head -n5|tail -n1 would be). Unique persistend IDs are 
>>> unfavorable as well; names, as used with xt_quota2/xt_NFACCT can be 
>>> remembered much more easily.
>>
>> Rule names could serve this, couldn't they?  And rules can be identified
>> by -m comment if batch processing is required.
>
> Then you can just as well use nfacct's name.

Sorry, I didn't write what I wanted to.  I meant chain names, not rule
names (which don't even exist).  Also, bringing up -m comment was a
mistake, please disregard it.

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> What you propose is hackish.

Do you consider creating a new chain with a single empty rule hackish?
I accept that nfacct is a more transparent solution.  But I don't think
those single rule counter chains are that bad, either.  And they are
potentially more flexible (which may be an advantage or a disadvantage
as well).  And they don't require adding (and maintaining) new code.

> You parse text-based outputs, which is not the nice way to make
> things.

Agreed.  But I don't see the principal difference: just as you provide
libnetfilter_acct, someone could provide a similar library for handling
the rule counters (maybe such a library is already available, I don't
know).  Also, I bet 98% of the uses would involve shell scripts anyway,
using nfacct_get http-traffic or iptables -vL http-traffic for much the
same effect. :)

Please don't think I'm against your code.  My point was that there is a
viable alternative already present in the kernel.  I will shut up now.
-- 
Regards,
Feri.
