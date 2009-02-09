From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/6] rework of nf_log refactoring
Date: Mon, 09 Feb 2009 22:08:14 +0100
Message-ID: <49909B3E.0@inl.fr>
References: <1231312622.4137.7.camel@ice-age>	 <1231358734-20958-5-git-send-email-eric@inl.fr>	 <alpine.LSU.2.00.0901080054080.29344@fbirervta.pbzchgretzou.qr> <1231452093.10299.2.camel@ice-age> <49906B27.9040004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:51573 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZBIVIW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:08:22 -0500
In-Reply-To: <49906B27.9040004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Patrick McHardy a =E9crit :
> Eric Leblond wrote:
>> Hi,
>>
>> Le jeudi 08 janvier 2009 =E0 00:56 +0100, Jan Engelhardt a =E9crit :
>>> On Wednesday 2009-01-07 21:05, Eric Leblond wrote:
>>>> --- a/net/netfilter/nf_log.c
>>>> +++ b/net/netfilter/nf_log.c
>=20
> I'm not sure whether I'm looking at the latest version. Could you
> resend all logging patches I haven't applied yet please?
>=20
> My tree for 2.6.30 (not merged up with the patches for 2.6.29 yet,
> but I'll take care of any conflicts myself) is available at:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

Requested patches are following this mail. I've also added the reworked
"netfilter: fix nflog timeout handling" patch.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
