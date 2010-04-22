From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Thu, 22 Apr 2010 12:55:28 +0200
Message-ID: <4BD02B20.7070008@trash.net>
References: <1271856792-20872-1-git-send-email-jengelh@medozas.de> <1271856792-20872-2-git-send-email-jengelh@medozas.de> <4BCF001D.4090304@trash.net> <alpine.LSU.2.01.1004220100530.6257@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63030 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0DVKz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:55:29 -0400
In-Reply-To: <alpine.LSU.2.01.1004220100530.6257@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-04-21 15:39, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> xt_condition can be used by userspace to influence decisions in rules
>>> by means of togglable variables without having to reload the entire
>>> ruleset.
>>> +
>>> +	var->refcount = 1;
>>> +	var->enabled  = false;
>>> +	var->status_proc->data = var;
>>> +	wmb();
>> Jan, while I'm pretty patient, I don't appreciate having to repeat
>> the same thing multiple times:
>>
>>>> Please always comment the use of memory barriers.
> 
> I am sorry I missed that; it seemed clear within the first 10 lines
> of your mail (which just quoted the patch) that I sent out the
> rcu-bugged variant and skipped the rest.
> 
> My share on the topic of patience - let me express that merges seemed
> to be processed faster in the rc1 week once a good-looking series was
> posted. As for maintenance, I think there should also be less
> turnarounds/resends. No doubt that tires out maintainers and
> bystanders alike looking at the same patch again and again.

That's not a big problem, I'd rather have a few more resends than
merge something buggy. I mainly would like submitters to be careful
about their patches. I usually review my own work multiple times
before sending it out since I know how easily something stupid can
slip in. Lets leave it at that :)

> Adding
> routing-by-oif could have easily be added as a patch on top, given it
> was a feature not a bugfix. 

Yeah, it was a bigger change than I anticipated.

> (N.B.: Where did iptables.git/extensions/libxt_TEE.c go? You asked for
> it, but it did not show up yet either.)

I used it for testing. As usual, it will be merged once the release
for the next kernel version is out. I don't want to go back to release
userspace parts for things which are not included in mainline yet.
That has bit us multiple times when we had to change the ABI.
