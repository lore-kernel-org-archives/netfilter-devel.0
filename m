From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Fri, 21 Jan 2011 14:57:57 +0100
Message-ID: <4D3990E5.1010402@netfilter.org>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <201101211353.40377.richard@nod.at> <4D398956.3030201@netfilter.org> <201101211438.31772.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36549 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1AUN6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:58:01 -0500
In-Reply-To: <201101211438.31772.richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/01/11 14:38, Richard Weinberger wrote:
> Am Freitag 21 Januar 2011, 14:25:42 schrieb Pablo Neira Ayuso:
>>> Using the TRACE target the kernel would produce a lot of log messages
>>> which may slow down the firewall. Especially when tracing ESTABLISHED
>>> connections. My extension does not have this overhead.
>>
>> AFAICS, this is an ad-hoc optimization for a specific case that you
>> need. So, it's basically a subset of the trace infrastructure.
> 
> But without the overhead...

I guess that one runs after defining the rule-set for first time or if
it finds a problem in his rule-set. Not in his daily ruleset.

>>> All I want is a friendlier output from conntrack, why should I reinvent
>>> the wheel?
>>
>> Why doing things in user-space is reinventing the wheel?
> 
> When I'm using TRACE I'll get a lot of log messages.
> But I'm not interested in logs, I have already enough of them.

I know that.

I'm proposing you to make a program in user-space that can process them
and print the output in some compact format, more useful than the current.

> I want a session table where I can see what sessions are allowed by
> which rules.

I know what you want but who else in this world needs this in the Linux
kernel.

Of course, you can maintain this hack in your internal tree if you need it.
