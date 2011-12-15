From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Thu, 15 Dec 2011 21:23:34 +0100
Message-ID: <871us5bn3t.fsf@tac.ki.iif.hu>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	<CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
	<20111214133010.GA3155@1984>
	<CABa6K_HLc2w5K4taYmrNfhdXTPZsvE=OmdQtNnYBm32Erw8yBA@mail.gmail.com>
	<alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Changli Gao <xiaosuo@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:50839 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1LOUXl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:23:41 -0500
In-Reply-To: <alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Wed, 14 Dec 2011 16:59:43 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:

> On Wednesday 2011-12-14 15:52, Changli Gao wrote:
>
>> On Wed, Dec 14, 2011 at 9:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>>> On Wed, Dec 14, 2011 at 09:12:52PM +0800, Changli Gao wrote:
>>>>
>>>> Why not use the counters of iptables instead?
>>>>
>>>> iptables-save -c
>>>
>>> If you want to obtain the sum of the counters that match some criteria,
>>> you have to iterate over the whole list of existing rules, look for
>>> matchings and update the counters.
>>
>> As I said in another thread, you can redirect the traffic to a
>> separated chain, and use the counters of that chain.
>
> UDCs (user defined chains) don't have counters, though.

So put an empty rule into them.  The ip_ plugin of Munin uses this
technique for quite some time.

>>> Moreover, if you have a large rule-set, polling periodically
>>> iptables-save -c can be expensive.
>>
>> I got it. Thanks. Maybe we can index the entries in the kernel, and
>> add a new interface to get the counters of a special entry with a
>> entry ID.
>
> Relying on the rule number is a terrible idea (just like 
> iptables-save|head -n5|tail -n1 would be). Unique persistend IDs are 
> unfavorable as well; names, as used with xt_quota2/xt_NFACCT can be 
> remembered much more easily.

Rule names could serve this, couldn't they?  And rules can be identified
by -m comment if batch processing is required.
-- 
Regards,
Feri.
