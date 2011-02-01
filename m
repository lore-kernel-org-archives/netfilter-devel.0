From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Tue, 1 Feb 2011 12:51:25 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102011246520.4106@obet.zrqbmnf.qr>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com> <alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr> <AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com> <alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
 <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com> <4D46824B.2010706@netfilter.org> <AANLkTimLxY-sM28GHq_RYKyMzN-7n6VXaDJD7FLz4vv4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, wp@elim.net
To: JeHo Park <linuxpark@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <AANLkTimLxY-sM28GHq_RYKyMzN-7n6VXaDJD7FLz4vv4@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tuesday 2011-02-01 02:50, JeHo Park wrote:
>>> anyway, i wonder why there is no TCP payload in the skb of the string
>>> or wurl match.
>>
>> Because you only see the first packet of the flow in the NAT table.
>>
>first, i thought or assumed what you said like above is from the
>reason that NAT mapping is first started from L3 IP connection mapping
>[...] but it is not based on TCP contents.
>so you said it is not possible to rediect such connection.
>is it right?

The simple fact is that there is usually no content in the
TCP SYN packet that you could possibly match on.

>> You should use the string match in the filter or raw tables.
>>
>
>and second, i think some people might also want such a functionality
>like what i want to do, redirection some connection to other server
>judging from its TCP contents infomation. [in this case, the URI
>infomation of the HTTP transaction]

That is what proxies like squid are for.

See http://l7-filter.sourceforge.net/FAQ#usage for an elaborate
answer.
