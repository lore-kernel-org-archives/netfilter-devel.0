From: Patrick McHardy <kaber@trash.net>
Subject: Re: Can NFQUEUE accept/continue when there is no userspace listener
 registered ?
Date: Fri, 05 Nov 2010 10:29:43 +0100
Message-ID: <4CD3CE87.2040901@trash.net>
References: <4CD22E08.2060300@netbauds.net> <4CD238A2.8070900@trash.net> <4CD34AE5.8090606@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Darryl Miles <darryl-mailinglists@netbauds.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56402 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0KEJ3s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:29:48 -0400
In-Reply-To: <4CD34AE5.8090606@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.11.2010 01:08, Pablo Neira Ayuso wrote:
> On 04/11/10 05:37, Patrick McHardy wrote:
>> On 04.11.2010 04:52, Darryl Miles wrote:
>>> Is there any mechanism which would allow additional options to NFQUEUE
>>> target to instruct the kernel what to do:
>>>
>>>   --action-no-listener NF_ACCEPT|NF_DROP|CONTINUE  (with NF_DROP being
>>> the default)
>>>   --action-backlog-overflow NF_ACCEPT|NF_DROP|CONTINUE   (with NF_DROP
>>> being the default)
>>
>> --action-no-listener is hard to do because the rule has no direct
>> connection to the queue and backend queueing mechanism and thus
>> it can't determine whether a listener exists. There's also currently
>> no way to propagate that information to the backend. Well, maybe
>> you could encode it in the verdict, similar to the queue number.
>>
>> --action-backlog-overflow should be pretty easy to add to the
>> queueing backend itself (nfnetlink_queue), however when the packet
>> reaches the backend, it has already left the ruleset, so it won't
>> continue in the chain but instead continue as if a verdict of
>> NF_ACCEPT had been issued.
> 
> We can add two new netlink attributes like:
> 
> * NFQA_CFG_NO_LISTENER_VERDICT
> * NFQA_CFG_OVERFLOW_VERDICT
> 
> These can be used to send messages from user-space to configure the
> instance, these will remain per-process parameters. It's similar to what
> we do with NFQA_CFG_QUEUE_MAXLEN.

Well, no listener can't be configured in nfnetlink_queue since the
instance goes away with the listener :) That's why I was saying that
this information needs to be included in the NF_QUEUE verdict.
