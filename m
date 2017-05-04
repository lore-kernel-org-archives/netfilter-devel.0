From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Thu, 4 May 2017 17:37:25 +0200
Message-ID: <4d219738-b12e-3c33-7ba3-bcb54b82bf2a@redhat.com>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia> <20170504134419.GG13320@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751330AbdEDPh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 11:37:27 -0400
In-Reply-To: <20170504134419.GG13320@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/04/2017 03:44 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, May 04, 2017 at 02:34:21PM +0200, Phil Sutter wrote:
>>> Being able to retrieve an added rule's handle atomically is a crucial
>>> feature for scripts invoking nft command: Without it, there is no way to
>>> be sure a handle extracted from 'nft list ruleset' command actually
>>> refers to the rule one has added before or that of another process which
>>> ran in between.
>>>
>>> Extracting an added rule's handle itself is not an easy task already,
>>> since there is a chance that a given rule is printed differently than
>>> when it was added before. A simple example is port number vs. service
>>> name:
>>>
>>> | nft add rule ip t c tcp dport { ssh, 80 } accept
>>>
>>> There is no way to make 'nft list ruleset' return the rule just like
>>> this as depending on whether '-nn' was given or not, it either prints
>>> the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
>>> that was used when adding it.
>>>
>>> This patch prints an identifying string for each added rule which may be
>>> used as single parameter to a later 'nft delete rule' command. So a
>>> simple scripting example looks like this:
>>>
>>> | handle=$(nft add rule ip t c counter)
>>
>> This is a hack.
>>
>> We should follow the rule description path.
> 
> You mean delete-by-name?
> 
> Its just as ugly, just a different kind of ugly.
> 
Delete by name for rules would be an atomic operation. The solution above is 
not as two calls are needed to remove one rule. Saving the handles while the 
rule has been added is not possible all the time and will most likely require 
bigger changes in several projects.

I also do not understand why delete by name is possible for tables, chains and 
sets but not for rules.

Delete by name for rules is also something that would help to be able to create 
an nftables backend for firewalld easily. firewalld is using a transaction 
model for iptables, that I'd also like to use for nftables. With this it is 
possible to add and remove rules in one -restore call for IPv4 and one for 
IPv6. Using this with gathering handles will take more time and will not be atomic.

Though: Flushing the whole rule set and recreation of the new rule set could be 
done in an atomic operation. But it will destroy everything else.

> Will you delete the first match?  The last one?  All of them? > --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
