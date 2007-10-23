From: Guillaume Leccese <guillaume.leccese@oxalide.com>
Subject: Re: iptables logging to syslog: performance problem
Date: Tue, 23 Oct 2007 18:41:48 +0200
Message-ID: <471E244C.8000009@oxalide.com>
References: <471E0F68.4010700@oxalide.com> <471E181E.3050505@trash.net> <471E1A16.5060404@oxalide.com> <471E1ECF.3030300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471E1ECF.3030300@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy a =E9crit :
> Guillaume Leccese wrote:
>> Patrick McHardy a =E9crit :
>>>> On a 2.6.19.1 kernel box (nfct patch from Julian
>>>> http://www.ssi.bg/~ja/nfct/) we have a strange performance problem=
=2E
>>>>
>>>> When a scan occur on a /24 network handled by the firewall (on a=20
>>>> filtered
>>>> port) packets dropping produces a syslog output. During the loggin=
g=20
>>>> process,
>>>> the traffic is at a frozen state (2 seconds to 30 seconds,=20
>>>> depending of the
>>>> number of ports scanned).
>>>>
>>>> [...]
>>>> When output to syslog is not effective, there is no performance=20
>>>> decrease.
>>>>
>>>> More details about the configuration:
>>>>
>>>> - Linux 2.6.19.1, module activate, iptables not in module
>>>> - e1000, tygon 3 and sundance drivers in module
>>>> - bonding device in module
>>>> - 2x e1000, driver v7.6.9 stable, in bonding
>>>> - Keepalived 1.1.12-1, Debian apt version
>>>
>>> Are you using serial console?
>>>
>>
>> Hi Patrick,
>>
>> Do you ask me if the serial console is compiled in the kernel or if=20
>> I'm using serial console for remote control ?
>
> Whether you use serial console for logging.
>
>>
>> 1/ yes, see the .config in attachment
>>
>> 2/ no, we use ssh
>
> In case you're not using the serial console for logging, can you
> reproduce it without Julian's patches?

I can't use actually working environment without Julian's patches.

Tomorrow, I will try to reproduce on a test environment without the=20
patch, but I not sure I can achieve that because we can't reach the sam=
e=20
network load.

Thx for your help (and sorry for my english ^^).

Guillaume
