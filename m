From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 0/2] xtables-eb for the compatibility layer
Date: Wed, 05 Feb 2014 21:43:12 +0100
Message-ID: <52F2A260.2060806@pandora.be>
References: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:54174 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaBEUsT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:48:19 -0500
In-Reply-To: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giuseppe Longo schreef op 5/02/2014 19:17:
> Hi,
> this patchset implements ebtables for the nftables compatibility layer.
> I would explain some points:
> - I didn't figure out how to replace some parts of codes, for istance:
>    from xtables-eb.c, line 928:
>    t = (struct ebt_u_target *)new_entry->t;
>    if ((t->parse(c - t->option_offset, argv, argc, new_entry, &t->flags, &t->t))) {
> 	  if (ebt_errormsg[0] != '\0')
> 		  return -1;
> 	  goto check_extension;
>    }
>
>    /* Is it a match_option? */
>    for (m = ebt_matches; m; m = m->next)
> 	  if (m->parse(c - m->option_offset, argv, argc, new_entry, &m->flags, &m->m))
> 		  break;
>
>    if (m != NULL) {
> 	  if (ebt_errormsg[0] != '\0')
> 		  return -1;
> 	  if (m->used == 0) {
> 		  ebt_add_match(new_entry, m);
> 		  m->used = 1;
> 	  }
> 	  goto check_extension;
>    }
>
> Looking at extensions, I noticed that any xtables_match/xtables_target have parse functions. Maybe I'm wrong.

The parse functions of the targets/matches/watchers will return 0 if the 
command-line argument isn't one of their options. If the parse function 
returns a non-zero value, the command line option belongs to that 
target/match/watcher. So, unless you don't want support for 
target/watcher/match command-line arguments, you will need that code.

> Even the code from line 992 is not very clear, about final checks. I don't know if I can remove this part of code.

The code you commented out checks for loops in the call chain and runs 
the final_check functions of the target/matches/watchers. As an example, 
the ebt_ip module's final_check function makes sure the Ethernet 
protocol is specified to be IPv4.
I see you comment out more stuff below that. All I can tell you is that 
it sure is required for correct behavior in the oldschool ebtables 
program. Please take the time to figure this out (read the code 
comments, step through the code with a debugger) because I doubt this 
will be a smooth and stable integration process otherwise.

cheers,
Bart


