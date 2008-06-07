From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters (ver.
 2)
Date: Sat, 07 Jun 2008 15:31:18 +0200
Message-ID: <484A8DA6.1080808@trash.net>
References: <48459c0c.4MdiVlMLZBmNAw6M%olel@ans.pl> <484916E2.3090200@trash.net> <Pine.LNX.4.64.0806061848340.12641@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44961 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYFGNbX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 09:31:23 -0400
In-Reply-To: <Pine.LNX.4.64.0806061848340.12641@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Fri, 6 Jun 2008, Patrick McHardy wrote:
> 
>> Looks pretty good, just one or two minor things below. What would
>> be nice though is to reduce patch size a bit, two suggestions for
>> this are:
>>
>> - move seq_print_acct() changes to seperate cleanup patch
> 
> But those are not only cleanup changes but changes mainly required by 
> ct_extend implementation. The only cleanup change is that there is now 
> one function instead of two identical. Should I first change both 
> seq_print_counters into seq_print_acct and then merge them in an 
> additional post-patch?

If it makes sense, sure. Those were just suggestions, if
they don't make sense, feel free to ignore them :)

>>>  struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int 
>>> *vmalloced)
>>> @@ -1165,6 +1174,10 @@ int __init nf_conntrack_init(void)
>>>      if (ret < 0)
>>>          goto out_fini_expect;
>>>  +    ret = nf_conntrack_acct_init();
>>> +    if (ret < 0)
>>> +        goto out_fini_acct;
>>> +
>>>      /* For use by REJECT target */
>>>      rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
>>>      rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
>>> @@ -1177,6 +1190,7 @@ int __init nf_conntrack_init(void)
>>>       return ret;
>>>  +out_fini_acct:
>>
>> nf_conntrack_helper_fini(); ?
> 
> Hm... "helper"? You mean "acct"? 

No, I mean helper. If acct initialization fails, the helper
initialization was the last thing that succeeded and you need
to properly clean it up again.

> There is no nf_conntrack_acct_fini as 
> it seems to be currently unnecessary. So, this empty out_fini_acct seems 
> to be redundant here but I decided that adding it is cleaner than 
> calling "goto out_fini_*expect*" from the nf_conntrack_*acct*_init 
> error-path.

Good point, even though accounting and ct_extend are unloaded
together, for cleanness you should also unregister the extension
you've registered.
