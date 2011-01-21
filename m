From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Fri, 21 Jan 2011 12:26:09 +0100
Message-ID: <4D396D51.3070903@netfilter.org>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <201101210002.24922.richard@nod.at> <4D395950.8060304@netfilter.org> <201101211213.57308.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1AUL0N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:26:13 -0500
In-Reply-To: <201101211213.57308.richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/01/11 12:13, Richard Weinberger wrote:
> Am Freitag 21 Januar 2011, 11:00:48 schrieb Pablo Neira Ayuso:
>> On 21/01/11 00:02, Richard Weinberger wrote:
>>> Am Donnerstag 20 Januar 2011, 23:52:25 schrieb Jan Engelhardt:
>>>> On Thursday 2011-01-20 23:47, Richard Weinberger wrote:
>>>>> Hi,
>>>>>
>>>>> as a firewall admin I would like to see which rules allow
>>>>> the connections through my firewall.
>>>>> A relationship between conntrack and firewall rules would be nice.
>>>>> The next five patches bring this feature to the Linux Netfilter.
>>>>>
>>>>> First a small example.
>>>>> Consider this iptables rules:
>>>>> -A INPUT -m state --state ESTABLISHED,RELATED -j APPROVE --rule-id 1
>>>>> -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j APPROVE --rule-id
>>>>> 2 -A INPUT -p tcp --dport 22 -m state --state NEW -j APPROVE --rule-id
>>>>> 3 -A INPUT -p icmp -m state --state NEW -j APPROVE --rule-id 4
>>>>>
>>>>> The APPROVE target is the same as ACCEPT but it stores also a rule id
>>>>> into the connection tracking entry.
>>>>
>>>> What about connmark? You could have used that. Perhaps combined with the
>>>> use of -j TRACE that can show which rules were processed before a
>>>> verdict was issued.
>>>
>>> Yeah, I know commark and TRACE but they are quite clumsy to use for such
>>> a purpose.
>>
>> Why are the clumsy for this purpose?
> 
> Because I would need more than one iptables command to model a firewall rule.
> Or can you show me a simple iptables configuration using connmark which 
> achieves the same as my APPROVE example above?

Just a couple of extra rules to restore and save the connmark. Right?
