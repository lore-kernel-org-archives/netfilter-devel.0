From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [PATCH 0/2] xtables-eb for the compatibility layer
Date: Thu, 6 Feb 2014 12:20:35 +0100
Message-ID: <CAFpD06SaqiRwPzzQjf3r64m4y3OqfPVej=7agMwn_cJSKu5GGw@mail.gmail.com>
References: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
	<52F2A260.2060806@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:46074 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaBFLUk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:20:40 -0500
Received: by mail-we0-f176.google.com with SMTP id q58so1157749wes.7
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2014 03:20:39 -0800 (PST)
In-Reply-To: <52F2A260.2060806@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Bart,
thank you for your explanation, I have to figure out how to port the
extensions to xtables.
It's more clearer now.

Cheers,
Giuseppe

2014-02-05 Bart De Schuymer <bdschuym@pandora.be>:
> Giuseppe Longo schreef op 5/02/2014 19:17:
>>
>> Hi,
>> this patchset implements ebtables for the nftables compatibility layer.
>> I would explain some points:
>> - I didn't figure out how to replace some parts of codes, for istance:
>>    from xtables-eb.c, line 928:
>>    t = (struct ebt_u_target *)new_entry->t;
>>    if ((t->parse(c - t->option_offset, argv, argc, new_entry, &t->flags,
>> &t->t))) {
>>           if (ebt_errormsg[0] != '\0')
>>                   return -1;
>>           goto check_extension;
>>    }
>>
>>    /* Is it a match_option? */
>>    for (m = ebt_matches; m; m = m->next)
>>           if (m->parse(c - m->option_offset, argv, argc, new_entry,
>> &m->flags, &m->m))
>>                   break;
>>
>>    if (m != NULL) {
>>           if (ebt_errormsg[0] != '\0')
>>                   return -1;
>>           if (m->used == 0) {
>>                   ebt_add_match(new_entry, m);
>>                   m->used = 1;
>>           }
>>           goto check_extension;
>>    }
>>
>> Looking at extensions, I noticed that any xtables_match/xtables_target
>> have parse functions. Maybe I'm wrong.
>
>
> The parse functions of the targets/matches/watchers will return 0 if the
> command-line argument isn't one of their options. If the parse function
> returns a non-zero value, the command line option belongs to that
> target/match/watcher. So, unless you don't want support for
> target/watcher/match command-line arguments, you will need that code.
>
>
>> Even the code from line 992 is not very clear, about final checks. I don't
>> know if I can remove this part of code.
>
>
> The code you commented out checks for loops in the call chain and runs the
> final_check functions of the target/matches/watchers. As an example, the
> ebt_ip module's final_check function makes sure the Ethernet protocol is
> specified to be IPv4.
> I see you comment out more stuff below that. All I can tell you is that it
> sure is required for correct behavior in the oldschool ebtables program.
> Please take the time to figure this out (read the code comments, step
> through the code with a debugger) because I doubt this will be a smooth and
> stable integration process otherwise.
>
> cheers,
> Bart
>
>
