From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 1/2] New netfilter target to trigger LED devices
Date: Mon, 10 Nov 2008 20:34:44 +1000
Message-ID: <49180E44.3090808@shikadi.net>
References: <4916E36F.6000502@shikadi.net> <alpine.LNX.1.10.0811091439281.12658@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1851 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbYKJKer (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:34:47 -0500
In-Reply-To: <alpine.LNX.1.10.0811091439281.12658@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Firstly, I've declared xt_led_info in both the iptables library and the
>> kernel module.  This probably isn't ideal, but I wanted to avoid having
>> to create another header file, which presumably needs to be installed on
>> the user's system before iptables can be compiled.  Please let me know
>> what the preferred solution to this might be.
> 
> One solution is to have a file <linux/netfilter/xt_LED.h>
> in the kernel tree that is copied to the iptables tree
> at iptables/include/linux/netfilter/xt_LED.h.
> 
> But you just gave me something to consider, so keep it as it is right now.

Let me know what you decide!

> I do not think the help text is needed in code (either iptables
> or kernel). It should be in the iptables manpage, i.e.
> libxt_LED.man.

That's true, it's just that as a user I often go looking in the code when
I can't find any other documentation.  Are those example commands suitable
for inclusion in the manpage?  I think they're worth keeping somewhere.

>> +		if (check_inverse(optarg, &invert, NULL, 0))
>> +			exit_error(PARAMETER_PROBLEM,
>> +				"Unexpected `!' after --led-trigger-id");
> 
> Just remove check_inverse - no more intraposition negation support.
> Inversion is indicated by the "invert" variable already.

Does this mean I can remove those whole three lines?  Or do I still need to
check the value of "invert" and complain if it's specified?

>> +		if (strlen(optarg) > 15)
> 
> Why 15, if struct xt_led_info->name is 26 in size? Oh 'tis confusing!
> Try using
> 	strlen("netfilter-") + strlen(optarg) >= sizeof(led->name) instead.

Ah ok, I didn't realise that the compiler can optimise away the strlen()
call.  In that case I don't have any problem with doing it that way.

>> +			led->delay = atoi(optarg);
> 
> strto(u)l, for great justice :)

No problem.  What's the benefit of using strto(u)l over atoi()?

> iptables-restore does not recognize single-quoted words, you will
> have to use double quotes.
> 
> Or just forbid quote characters altogether?

I was going to forbid quote characters, but then I thought that people
may want to use extended characters (dollar signs perhaps, or other
characters that could be interpreted by the shell) so I thought
quoting the output would be less restrictive.

Maybe I should only allow alphanumerics and basic punctuation?

>> +	.size		= XT_ALIGN(sizeof(struct xt_led_info)),
>> +	.userspacesize	= XT_ALIGN(sizeof(struct xt_led_info)),
> 
> Wow did you actually try this? Since you need...
> 
> 	.userspacesize = offsetof(struct xt_led_info, internal_data)

Ah ok, I found a PDF of yours that explains this properly, I
misinterpreted the purpose of the field (I thought it was comparing
existing valid structures together, rather than comparing a new
structure against an existing one.)  I think this worked for me because
I'm in the habit of removing rules by index (iptables -D INPUT 1)

>> +.BI "--led-delay " "ms"
> 
> I prefer \fB/\fI over .B/.I because they read more like inline HTML,
> but that's me.
> 
> No trailing .PP.

That's fine, I've never used whatever that markup is before (I don't
even know what it's called...!)  I just edited one of the other target
pages.

Thanks again for your feedback.  I'll wait a day or two in case
anyone else has any other comments and then resubmit.

Cheers,
Adam.

