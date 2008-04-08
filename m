From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/24] Fix all remaining warnings (missing declarations,
 missing prototypes)
Date: Tue, 08 Apr 2008 17:30:31 +0200
Message-ID: <47FB8F97.7000406@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <d9e426312f2513c8d719a8ca65c50d3bde57a10b.1207495183.git.jengelh@computergmbh.de> <47F8EF28.1000801@trash.net> <alpine.LNX.1.10.0804081640050.2229@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42436 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYDHPad (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:30:33 -0400
In-Reply-To: <alpine.LNX.1.10.0804081640050.2229@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-04-06 17:41, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> --- a/extensions/libip6t_LOG.c
>>> +++ b/extensions/libip6t_LOG.c
>>> @@ -269,6 +269,7 @@ static struct ip6tables_target log_target6 = {
>>>      .extra_opts    = LOG_opts,
>>>  };
>>>  
>>> +void _init(void);
>>>  void _init(void)
>>>  {
>>>   register_target6(&log_target6);
>> I don't like this very much.
> 
> But it is relatively error-safe.
> 
>> A global prototype
> 
> I remember why I did not do that... every .c file would have to
> #include "proto.h"
> or some kind - is this really that badly needed? This would also
> cause a needless recompilation of all modules if the list of
> modules changed.

I meant something like:

include/x_tables.h:

extern void _init(void);
extern void _exit(void);

Actually this should really be defined by gcc in my opinion.

>> or simply using __attribute__ ((constructor)) and
>> __attribute__ ((destructor)) would be preferred.
> 
> Been there, done that, threw it out. Doing a CTOR with iptables-static
> leads to a NULL deref because the ctors get run before any of the iptables
> data structures are initialized.
> 
> Of course, one can always cook up more and more magic, i.e. test
> for
> 
>    if (!initalized)
>        run_init_first();
> 
> in a ctor (as well as main(), for consistency), but that's the least
> thrilling thing to do IMO.

Good point, that idea sucks :)

