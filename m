From: JeHo Park <linuxpark@gmail.com>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 20:17:33 +0900
Message-ID: <AANLkTikYs5cvpeuT+thxXGtPA=xosVG05BUk4VWGc8eG@mail.gmail.com>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>
	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>
	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>
	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr>
	<AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
	<4D46824B.2010706@netfilter.org>
	<4D469007.7080606@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	wp@elim.net
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47281 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1AaLRg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:17:36 -0500
In-Reply-To: <4D469007.7080606@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thanks pablo, pascal

i just want the client who try to connect any specified site  to
redirect my HTTP proxy server.
but judging from your answers, it seems impossible to filter that
client packets in the NAT table.
anyway thanks


On Mon, Jan 31, 2011 at 7:33 PM, Pascal Hambourg
<pascal.mail@plouf.fr.eu.org> wrote:
> Hello,
>
> Pablo Neira Ayuso a =C3=A9crit :
>> On 31/01/11 03:47, JeHo Park wrote:
>>> anyway, i wonder why there is no TCP payload in the skb of the stri=
ng
>>> or wurl match.
>>
>> Because you only see the first packet of the flow in the NAT table.
>
> And the first packet of a TCP connection usually carries no data.
> If you what you want to achieve is NAT a TCP connection based on the
> payload, I am afraid this is not possible because the definitive NAT
> mapping is defined from the first packet only.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
