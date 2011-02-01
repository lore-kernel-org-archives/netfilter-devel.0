From: JeHo Park <linuxpark@gmail.com>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Tue, 1 Feb 2011 10:50:34 +0900
Message-ID: <AANLkTimLxY-sM28GHq_RYKyMzN-7n6VXaDJD7FLz4vv4@mail.gmail.com>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>
	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>
	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>
	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
	<AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
	<4D46824B.2010706@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, wp@elim.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34046 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1BABuf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 20:50:35 -0500
In-Reply-To: <4D46824B.2010706@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello Pablo

i have two more questions

On Mon, Jan 31, 2011 at 6:35 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On 31/01/11 03:47, JeHo Park wrote:
>> hello jan
>> i see, i took mistake. Ccs.. :-)
>> anyway, i wonder why there is no TCP payload in the skb of the string
>> or wurl match.
>
> Because you only see the first packet of the flow in the NAT table.
>
first, i thought or assumed what you said like above is from the
reason that NAT mapping is first started from L3 IP connection mapping
[origin and expect tuples..] and from TCP helper [for TCP port
infomation ..etc] but it is not based on TCP contents.
so you said it is not possible to rediect such connection.
is it right?

> You should use the string match in the filter or raw tables.
>

and second,
i think some people might also want such a functionality like what i
want to do,
redirection some connection to other server judging from its TCP
contents infomation.
[in this case, the URI  infomation of the HTTP transaction]
i want to know how you think about ..

previously thanks ~
