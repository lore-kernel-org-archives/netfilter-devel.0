From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Fri, 21 Jan 2011 15:09:05 +0000
Message-ID: <4D39A191.1050703@googlemail.com>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <201101211353.40377.richard@nod.at> <4D398956.3030201@netfilter.org> <201101211438.31772.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Weinberger <richard@nod.at>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1AUPJN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:09:13 -0500
Received: by wyb28 with SMTP id 28so1897212wyb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jan 2011 07:09:12 -0800 (PST)
In-Reply-To: <201101211438.31772.richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>> All I want is a friendlier output from conntrack, why should I reinvent
>>> the wheel?
>>>       
>> Why doing things in user-space is reinventing the wheel?
>>     
>
> When I'm using TRACE I'll get a lot of log messages.
> But I'm not interested in logs, I have already enough of them.
> I want a session table where I can see what sessions are allowed by
> which rules.
> I would have to write a tool like conntrack which builds me a session table
> from all these logs.
>   
I personally like the patch and find it quite useful, though I also 
think that tracing/tracking/matching sessions and rules could be 
improved and made more easier for the end user. That is especially true 
when one has a large number of rules in a particular chain.

As things stand, in order to trace a particular session and match it 
with a rule (using your patch) I have to execute iptables (or conntrack) 
twice in order to get what I need. Even if I use the line-numbers option 
to show rule numbers in a particular chain, that won't be straight 
forward when I have large number of rules.

It would be better if this matching is done (again, by using the rule 
numbers provided by your patch) with a userspace tool, may be conntrack, 
or similar, which shows those matches as well as the rules in question, 
and present them in a form, which does not require me to scan for those 
matches over and over. Just my two pence, of course, and I hope I am 
on-topic this time!

