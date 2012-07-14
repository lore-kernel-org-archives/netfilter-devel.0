From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Sat, 14 Jul 2012 14:00:52 +0100
Message-ID: <50016D84.5080207@googlemail.com>
References: <50002CEF.508@googlemail.com> <1342194935.11019.12.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53234 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2GNNBA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:01:00 -0400
Received: by wibhm11 with SMTP id hm11so1426496wib.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jul 2012 06:00:59 -0700 (PDT)
In-Reply-To: <1342194935.11019.12.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> No work is planned on that but it is a good idea.
>   
Yeah, I thought as much.

>> If not, I think I have enough PostgreSQL experience and could alter that script to include such implementation, though I might need help with the NFLOG/ULOGD2 part as I am fairly new to this.
>>     
>
> I'm here to help ;)
>   
OK, for now I have some general queries with regards to ulogd2. When I 
gain more knowledge (and experience) my queries will become more 
specific. For now though I have to sort out the following:

In the manual there is a very good example on how to use NFLOG (as a 
iptables target), but I have no idea how to apply and select NFACCT and 
NFCT. How do I use this?

OK, I defined 2 stacks which use both NFCT and NFACCT, but how do I tell 
iptables how to use them? I presume this is in a similar way to NFLOG 
(with a target), but in that manual there are no examples (or even 
hints) given on how to use that.

Also, there are quite a few plugins which I have just a vague idea what 
they do (they are not documented in the manual - I presume because they 
were recently introduced) - GPRINT springs to mind, NACCT is the other. 
Is there a description on the purpose of these and their configuration 
parameters, if any?

Probably my last 2 queries for now: when I define a stack, I use a 
series of plugins to define a chain - from the source of where the 
packet originates, to a cascade of "filters" and then the output plugin.

Does the order of "filter" plugins matters (in other words, are they 
traversed from left-to-right in the order they are specified in the 
"stack" statement in ulogd.conf) or is this order irrelevant?

And the second query: usually every plugin, when defined in a stack 
statement has its own section when the various plugin parameters are 
defined. Say, "emu1" has its own "[emu1]" section in ulogd.conf and 
there I could define various parameters related to the LOGEMU plug in.

There are some plugins though, which do not have such section, which 
follows me to conclude that either defining that section is not 
mandatory (in which case I presume the plugin "assumes" default values) 
or, the plugin in question does not have any values to be specified, so 
no such section is needed. Am I correct in this assumption?

>> The idea I have is that the ulogd2 daemon should only be allowed INSERT permissions (nothing else) to the log tables, so that even if someone is able to hijack the ulogd2 connection to PostgreSQL somehow, they won't be able to see what has been logged, let alone alter it or delete it.
>>     
>
> That's a sane setup.
>   
I will dig much more deeper into this once I know how ulogd works as my 
knowledge of ulogd2 is not that great (yet!). My initial instinct is 
that I may have to alter this script slightly, because from what I 
gather ulogd2 is "sensing" the structure of the logging table by reading 
the "description" of it in PostgreSQL. That particular operation usually 
requires higher-than-needed privileges and in order to avoid that I 
might need to find other ways to impose the "insert-only" restriction, 
which, lets be clear, is what ulogd needs. Again, I might be wrong with 
this, but that is what my initial observations with the script and ulogd 
suggest.

> INL company is dead but I'm sure that Pierre is still reading this ML
> from another mail ;)
>   
Ah, that explains it! Well, if he reads this thread, I would love to get 
some feedback when I am confident enough to start digging into that 
script. ;-)

