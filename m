From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 14:59:21 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251457020.32573@obet.zrqbmnf.qr>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net> <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr> <4BAB64D1.2070404@trash.net>
 <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41596 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab0CYN7W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:59:22 -0400
In-Reply-To: <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 14:52, Jan Engelhardt wrote:
>On Thursday 2010-03-25 14:27, Patrick McHardy wrote:
>>>>
>>>>> -		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
>>>>> -			cipinfo->hash_mode);
>>>>> +		pr_info("unknown mode %u\n", cipinfo->hash_mode);
>>>> pr_err() actually seems more appropriate, if we'd use it consistenly
>>>> to report error conditions.
>>> 
>>> I felt that EINVAL parameter problems are not enough of an error
>>> condition to warrant the error level. It's not critical (as in:
>>> printer on fire), error I would associate with sda rejecting I/O,
>>> warning that an NFS server is slow to respond, notice that disk space
>>> is getting below 5% (not that the kernel does that, but that would be
>>> my judgment). The messages printed by checkentry functions is IMO
>>> just an additional information to the -EINVAL that's returned. Of course
>>> we can always change it anyway.
>>
>>Fair enough, but some consistency among modules would be great. There
>>are a few instances of pr_err/warning used for memory allocation errors
>>or invalid parameters in this patch.
>
>As far as I can see, I've been consistent.
>
>pcregrep -r 'pr_(?!info)' net/ipv4/netfilter/ net/ipv6/netfilter/
>net/bridge/netfilter/ net/netfilter/ | grep -v pr_debug |
>grep -v pr_fmt | less
>
>Only shows either lines outside .checkentry, or things that really
>are an error, such as xt_LED.c being unable to register its ledtrigger,
>which is not a "user parameter error" and thus would not be pr_info.
>
>If you see inconsistency, could you hint me towards it?

(Not all patches were initially created using spatch, which I have
just started using yesterday. But it's a great tool.)

So, I was searching for inconsistencies using the following semantic
patch, and the result was only the aforementioned xt_LED.c,
and nf_nat_rule.c (which I'll be fixing up).

// <smpl>
@ rule1 @
struct xt_match match;
identifier mcheck;
@@
 match.checkentry = mcheck;

@@
identifier rule1.mcheck;
@@
 mcheck(...) {
 <...
(
-pr_err
|
-pr_warning
|
-printk
)
+pr_info
 (...); ...>
 }

@ rule3 @
struct xt_target target;
identifier tcheck;
@@
 target.checkentry = tcheck;

@@
identifier rule3.tcheck;
@@
 tcheck(...) {
 <...
(
-pr_err
|
-pr_warning
|
-printk
)
+pr_info
 (...); ...>
 }
// </smpl>
