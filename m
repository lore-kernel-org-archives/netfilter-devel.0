From: JeHo Park <linuxpark@gmail.com>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 11:59:14 +0900
Message-ID: <AANLkTi=mDjEiMfO6H91nmTHCgawQjMaXQADj2ETVvtvv@mail.gmail.com>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>
	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>
	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>
	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
	<AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
	<alpine.LNX.2.01.1101310348130.20455@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32785 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1AaC7R convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:59:17 -0500
In-Reply-To: <alpine.LNX.2.01.1101310348130.20455@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello jan ~

On Mon, Jan 31, 2011 at 11:51 AM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
> On Monday 2011-01-31 03:47, JeHo Park wrote:
>
> (Might as well avoid top posting?)
>
>>hello jan
>>i see, i took mistake. Ccs.. :-)
>>anyway, i wonder why there is no TCP payload in the skb of the string
>>or wurl match.
>
> Because TCP packets are allowed to have no payload.
>

is there any way to make TCP packets have payload ?
does it possible with only configuration ? or need some modification
of the source code ?

>
>>On Mon, Jan 31, 2011 at 11:38 AM, Jan Engelhardt =C2=A0wrote:
>>> *sigh* don't strip the Ccs
>>>
>>> On Monday 2011-01-31 03:24, JeHo Park wrote:
>>>>On Mon, Jan 31, 2011 at 11:09 AM, Jan Engelhardt =C2=A0wrote:
>>>>> On Monday 2011-01-31 02:53, JeHo Park wrote:
>>>>>>
>>>>>>the string match works well in filter table, but it does not work=
 in NAT.
>>>>>
>>>>> Oh it _does_ work in nat.
>>>>>
>>>>> But given that the nat table is an abstract configuration databas=
e
>>>>> rather than a filter, not all packets do a lookup.
>>>>
>>>>but i found in runtime with debugging code, there is no TCP data bu=
t
>>>>only TCP header in the skbuff of string match.
>>>
>>> Good, then this issue is resolved.
>>>
>>>
>>>>>>i used following iptables rules
>>>>>># =C2=A0iptables -A PREROUTING -t nat -p tcp --dport 80 -m string=
 --string
>>>>>>"goole.com" --algo bm -j DNAT --to-destination 10.10.10.125:80
>>>
>>>
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
