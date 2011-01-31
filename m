From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 11:33:43 +0100
Message-ID: <4D469007.7080606@plouf.fr.eu.org>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr> <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com> <4D46824B.2010706@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D46824B.2010706@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Pablo Neira Ayuso a =E9crit :
> On 31/01/11 03:47, JeHo Park wrote:
>> anyway, i wonder why there is no TCP payload in the skb of the strin=
g
>> or wurl match.
>=20
> Because you only see the first packet of the flow in the NAT table.

And the first packet of a TCP connection usually carries no data.
If you what you want to achieve is NAT a TCP connection based on the
payload, I am afraid this is not possible because the definitive NAT
mapping is defined from the first packet only.
