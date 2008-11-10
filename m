From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] New netfilter target to trigger LED devices
Date: Mon, 10 Nov 2008 12:10:28 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811101156060.32764@fbirervta.pbzchgretzou.qr>
References: <4916E36F.6000502@shikadi.net> <alpine.LNX.1.10.0811091439281.12658@fbirervta.pbzchgretzou.qr> <49180E44.3090808@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40476 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbYKJLKb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:10:31 -0500
In-Reply-To: <49180E44.3090808@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-10 11:34, Adam Nielsen wrote:
>
> That's true, it's just that as a user I often go looking in the code when
> I can't find any other documentation.  Are those example commands suitable
> for inclusion in the manpage?  I think they're worth keeping somewhere.

Yes. These commands should be made available to iptables users --
not developers (or those wanting to be one) to find it by chance
in net/netfilter/Kconfig.

>> > +		if (check_inverse(optarg, &invert, NULL, 0))
>> > +			exit_error(PARAMETER_PROBLEM,
>> > +				"Unexpected `!' after --led-trigger-id");
>> 
>> Just remove check_inverse - no more intraposition negation support.
>> Inversion is indicated by the "invert" variable already.
>
> Does this mean I can remove those whole three lines?  Or do I still need to
> check the value of "invert" and complain if it's specified?

You still need to check for it. If you grep for P_NO_INVERT in all .c
files you will find the shortest possible line to do so.

>
>> > +		if (strlen(optarg) > 15)
>> 
>> Why 15, if struct xt_led_info->name is 26 in size? Oh 'tis confusing!
>> Try using
>>  strlen("netfilter-") + strlen(optarg) >= sizeof(led->name) instead.
>
> Ah ok, I didn't realise that the compiler can optimise away the strlen()
> call.  In that case I don't have any problem with doing it that way.

Even if the compiler could not, you could use sizeof("foo")-1 to get "3".
That is a property of the C language.

>> > +			led->delay = atoi(optarg);
>> 
>> strto(u)l, for great justice :)
>
> No problem.  What's the benefit of using strto(u)l over atoi()?

Error detection, says the manual page. It is actually a good thing
to go with the consistency even if you do not care about errors.

>> iptables-restore does not recognize single-quoted words, you will
>> have to use double quotes.
>> 
>> Or just forbid quote characters altogether?
>
> I was going to forbid quote characters, but then I thought that people
> may want to use extended characters (dollar signs perhaps, or other
> characters that could be interpreted by the shell) so I thought
> quoting the output would be less restrictive.
>
> Maybe I should only allow alphanumerics and basic punctuation?

I thought about that - but I have come to the conclusion that most
character should be allowed so that people can use all the
extended characters like CJK.

>> I prefer \fB/\fI over .B/.I because they read more like inline HTML,
>> but that's me.
>> 
>> No trailing .PP.
>
> That's fine, I've never used whatever that markup is before

>(I don't even know what it's called...!)

Read the PDF to the end and you will find out ;-)
