From: Andrew Watts <akwatts@ymail.com>
Subject: Re: NFQUEUE verdicts - adding non-termination
Date: Fri, 12 Nov 2010 03:01:21 -0800 (PST)
Message-ID: <631109.9100.qm@web111016.mail.gq1.yahoo.com>
References: <4CDBCA8C.2000801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm21.bullet.mail.sp2.yahoo.com ([98.139.91.91]:29550 "HELO
	nm21.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755781Ab0KLLBW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:01:22 -0500
In-Reply-To: <4CDBCA8C.2000801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--- On Thu, 11/11/10, Patrick McHardy <kaber@trash.net> wrote:

>On 11.11.2010 10:01, Andrew Watts wrote:
>> Hi.
>> 
>> The NF_CONTINUE verdict that Darryl Miles brings up in his 11/4
>> post is very interesting. NF_CONTINUE would provide the NFQUEUE
>> target the added flexibility of, say, partial handling in
>> userspace. A queue-handler could have a set of criteria that,
>> when satisfied, would result in an immediate drop or accept. One
>> could then leave the rest of the packets to find their fate in the
>> chains/rules left to traverse. I would be interested in helping
>> to add this verdict if someone will take the lead (assuming a patch
>> hasn't already been written - has it?).

>There's no difference between returning NF_ACCEPT or a new NF_CONTINUE.
>Queueing happens outside of the ruleset context, so in either case the
>packet would continue through the network stack directly, not after
>the NFQUEUE rule.

I see. Is there a way to achieve this result under the current
infrastructure?

~ Andy



      
