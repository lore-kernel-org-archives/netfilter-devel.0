From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables logging to syslog: performance problem
Date: Tue, 23 Oct 2007 18:18:23 +0200
Message-ID: <471E1ECF.3030300@trash.net>
References: <471E0F68.4010700@oxalide.com> <471E181E.3050505@trash.net> <471E1A16.5060404@oxalide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Guillaume Leccese <guillaume.leccese@oxalide.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471E1A16.5060404@oxalide.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Guillaume Leccese wrote:
> Patrick McHardy a =E9crit :
>>> On a 2.6.19.1 kernel box (nfct patch from Julian
>>> http://www.ssi.bg/~ja/nfct/) we have a strange performance problem.
>>>
>>> When a scan occur on a /24 network handled by the firewall (on a=20
>>> filtered
>>> port) packets dropping produces a syslog output. During the logging=
=20
>>> process,
>>> the traffic is at a frozen state (2 seconds to 30 seconds, dependin=
g=20
>>> of the
>>> number of ports scanned).
>>>
>>> [...]
>>> When output to syslog is not effective, there is no performance=20
>>> decrease.
>>>
>>> More details about the configuration:
>>>
>>> - Linux 2.6.19.1, module activate, iptables not in module
>>> - e1000, tygon 3 and sundance drivers in module
>>> - bonding device in module
>>> - 2x e1000, driver v7.6.9 stable, in bonding
>>> - Keepalived 1.1.12-1, Debian apt version
>>
>> Are you using serial console?
>>
>
> Hi Patrick,
>
> Do you ask me if the serial console is compiled in the kernel or if=20
> I'm using serial console for remote control ?

Whether you use serial console for logging.

>
> 1/ yes, see the .config in attachment
>
> 2/ no, we use ssh

In case you're not using the serial console for logging, can you
reproduce it without Julian's patches?
