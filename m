From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 03:51:30 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101310348130.20455@obet.zrqbmnf.qr>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com> <alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr> <AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com> <alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
 <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: JeHo Park <linuxpark@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34568 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1AaCvb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:51:31 -0500
In-Reply-To: <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-01-31 03:47, JeHo Park wrote:

(Might as well avoid top posting?)

>hello jan
>i see, i took mistake. Ccs.. :-)
>anyway, i wonder why there is no TCP payload in the skb of the string
>or wurl match.

Because TCP packets are allowed to have no payload.


>On Mon, Jan 31, 2011 at 11:38 AM, Jan Engelhardt  wrote:
>> *sigh* don't strip the Ccs
>>
>> On Monday 2011-01-31 03:24, JeHo Park wrote:
>>>On Mon, Jan 31, 2011 at 11:09 AM, Jan Engelhardt  wrote:
>>>> On Monday 2011-01-31 02:53, JeHo Park wrote:
>>>>>
>>>>>the string match works well in filter table, but it does not work =
in NAT.
>>>>
>>>> Oh it _does_ work in nat.
>>>>
>>>> But given that the nat table is an abstract configuration database
>>>> rather than a filter, not all packets do a lookup.
>>>
>>>but i found in runtime with debugging code, there is no TCP data but
>>>only TCP header in the skbuff of string match.
>>
>> Good, then this issue is resolved.
>>
>>
>>>>>i used following iptables rules
>>>>># =C2=A0iptables -A PREROUTING -t nat -p tcp --dport 80 -m string =
--string
>>>>>"goole.com" --algo bm -j DNAT --to-destination 10.10.10.125:80
>>
>>
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
