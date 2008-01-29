From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] nf_conntrack ipv6: unused code and sparse fix
Date: Tue, 29 Jan 2008 13:54:15 +0100
Message-ID: <479F21F7.5010409@trash.net>
References: <20080124181628.545931850@vyatta.com>	<4798DCD6.6000906@trash.net>	<200801250124.m0P1OBt6004910@toshiba.co.jp> <200801280250.m0S2oWF1019241@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: shemminger@vyatta.com, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54187 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762551AbYA2NKO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:10:14 -0500
In-Reply-To: <200801280250.m0S2oWF1019241@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> Date: Fri, 25 Jan 2008 10:24:10 +0900 (JST)
> 
>> From: Patrick McHardy <kaber@trash.net>
>> Date: Thu, 24 Jan 2008 19:45:42 +0100
>>
>>> Stephen Hemminger wrote:
>>>
>>>  > +#ifdef notused
>>>  >  int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
>>>  > {
>>>  > 	struct sk_buff *s, *s2;
>>>  > @@ -694,6 +696,7 @@ int nf_ct_frag6_kfree_frags(struct sk_bu
>>>  >
>>>  >  	return 0;
>>>  >  }
>>>  > +#endif
>>>
>>> I'm wondering whether this is correct. I'm on the way out the
>>> door though, I'll look into it later. Thanks Stephen.
>> I'll check it, too. At least linux 2.6.15 (which is the first release
>> for nf_contrack) does not use the function. I try to recall the reason.
> 
> I agree to remove the function.
> 
> I seemed to forget to remove it when implementing nf_conntrack based on
> ip6_conntrack. The later used it to free the reassembled skb packet the
> original fragments on fail of tracking. But the function became unnecessary
> as result of changing data structure so that packets could be reassembled
> at new hook - NF_IP6_PRI_CONNTRACK_DEFRAG.


Thanks, I've added the missing include and removed this function.
