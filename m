From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Fri, 25 Jul 2014 11:57:59 -0500
Message-ID: <53D28C97.9000009@akamai.com>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com> <20140724084927.GB18404@breakpoint.cc> <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:9884 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508AbaGYQ6D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:58:03 -0400
In-Reply-To: <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/24/2014 05:53 AM, Patrick McHardy wrote:
> On 24. Juli 2014 09:49:27 GMT+01:00, Florian Westphal <fw@strlen.de> wrote:
>> Josh Hunt <johunt@akamai.com> wrote:
>>>      Currently when we do do this the new parameters are not enforced.
>>
>> Note that:
>>
>> -A INPUT -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10
>> --hashlimit-name test
>> -A INPUT -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 10
>> --hashlimit-name test
>>
>> doesn't work as expected either (rule #2 uses config options of #1).
>>
>> I think is behaviour is so unexpected that I would consider this a
>> bug...
>
> True, but it's a bug that has existed forever and I've seen scripts that actually rely on this.
>
> I'm not sure if we can silently change this behaviour.

Can you elaborate on what behavior they're relying on? It'd be helpful 
to know in case my approach can't be used we might be able to come up 
with an alternative.

In the case I describe with a restore it gives the user what I would 
expect to be undesired behavior since they would have explicitly changed 
the hash's config, but it's not having any affect. In Florian's case the 
user would have a number of rules where they've explicitly made 
different hash configurations, but all of the rules with the same hash 
name would behave the same as the first. Ignoring all of the configs the 
user input.

Thanks
Josh


