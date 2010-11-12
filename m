From: Stig Thormodsrud <stig@vyatta.com>
Subject: Re: NFQUEUE verdicts - adding non-termination
Date: Fri, 12 Nov 2010 11:54:02 -0800
Message-ID: <4CDD9B5A.4050800@vyatta.com>
References: <897598.58283.qm@web111015.mail.gq1.yahoo.com> <4CDBCA8C.2000801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Andrew Watts <akwatts@ymail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:59830 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab0KLTyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:54:05 -0500
In-Reply-To: <4CDBCA8C.2000801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/2010 02:50 AM, Patrick McHardy wrote:
> On 11.11.2010 10:01, Andrew Watts wrote:
>> Hi.
>>
>> The NF_CONTINUE verdict that Darryl Miles brings up in his 11/4 post is very interesting.
>>
>> NF_CONTINUE would provide the NFQUEUE target the added flexibility of, say, partial handling in userspace. A queue-handler could have a set of criteria that, when satisfied, would result in an immediate drop or accept. One could then leave the rest of the packets to find their fate in the chains/rules left to traverse.
>>
>> I would be interested in helping to add this verdict if someone will take the lead (assuming a patch hasn't already been written - has it?).
> 
> There's no difference between returning NF_ACCEPT or a new NF_CONTINUE.
> Queueing happens outside of the ruleset context, so in either case the
> packet would continue through the network stack directly, not after
> the NFQUEUE rule.

I've been interested in this thread since I recently converted our
version of snort inline to use NFQUEUE instead of QUEUE.  One of driving
factors was that I needed to have multiple QUEUE targets.  While I was
doing the work I was hoping there was a verdict like NF_RETURN, so that
if it passed the snort inspection then I could have another NFQUEUE
target that would do https domain filtering.  From reading this thread I
now understand why I can just continue, but I wondering what is that the
recommended approach for this type of use case?  As it is now, I think I
would need to have the 2nd NFQUEUE target on a different hook.

stig
