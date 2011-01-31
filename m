From: JeHo Park <linuxpark@gmail.com>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 11:47:38 +0900
Message-ID: <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>
	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>
	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>
	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52330 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1AaCrk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:47:40 -0500
In-Reply-To: <alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello jan
i see, i took mistake. Ccs.. :-)
anyway, i wonder why there is no TCP payload in the skb of the string
or wurl match.


On Mon, Jan 31, 2011 at 11:38 AM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
> *sigh* don't strip the Ccs
>
> On Monday 2011-01-31 03:24, JeHo Park wrote:
>>On Mon, Jan 31, 2011 at 11:09 AM, Jan Engelhardt <jengelh@medozas.de>=
 wrote:
>>> On Monday 2011-01-31 02:53, JeHo Park wrote:
>>>>
>>>>the string match works well in filter table, but it does not work i=
n NAT.
>>>
>>> Oh it _does_ work in nat.
>>>
>>> But given that the nat table is an abstract configuration database
>>> rather than a filter, not all packets do a lookup.
>>
>>but i found in runtime with debugging code, there is no TCP data but
>>only TCP header in the skbuff of string match.
>
> Good, then this issue is resolved.
>
>
>>>>i used following iptables rules
>>>># =C2=A0iptables -A PREROUTING -t nat -p tcp --dport 80 -m string -=
-string
>>>>"goole.com" --algo bm -j DNAT --to-destination 10.10.10.125:80
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
