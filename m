From: Patrick McHardy <kaber@trash.net>
Subject: Re: Using TRACE with ulogd2
Date: Mon, 12 Jan 2009 06:17:04 +0100
Message-ID: <496AD250.9020400@trash.net>
References: <alpine.LSU.2.00.0901061119270.28823@fbirervta.pbzchgretzou.qr> <1231238052.15452.32.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sean.donner@gmail.com
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55654 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZALFRU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:17:20 -0500
In-Reply-To: <1231238052.15452.32.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le mardi 06 janvier 2009 =E0 11:28 +0100, Jan Engelhardt a =E9crit :
>> Hi,
>>
>>
>> from discussions on IRC and after looking at the kernel's code, I go=
t=20
>> the impression that xt_TRACE's output can currently not be fed into=20
>> ulogd2, as xt_NFLOG does not make itself available for NF Core loggi=
ng=20
>> through nf_log_packet() as it does not register with nf_log.c's
>> nf_log_register().
>> Could you consider adding this?
>=20
> In fact, it should work but it can be a little tricky. You need to
> declare a stack starting with a NFLOG input plugin. This plugin has t=
o
> listen to event on nflog group 0:
>=20
> stack=3Dlog1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRIN=
TPKT,emu1:LOGEMU
>=20
> [log1]
> group=3D0
>=20
> Under that condition, you should receive messages from TRACE.

Indeed, I've used it like that and it works fine.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
