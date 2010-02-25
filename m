From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: make ipv6 optional for RAWNAT and SYSRQ
Date: Thu, 25 Feb 2010 01:05:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002250100020.2632@obet.zrqbmnf.qr>
References: <1266580375.26314.6.camel@tablet>  <alpine.LSU.2.01.1002191411280.17165@obet.zrqbmnf.qr> <1266669812.2097.21.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <peter.volkov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40869 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab0BYAFI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 19:05:08 -0500
In-Reply-To: <1266669812.2097.21.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-02-20 13:43, Peter Volkov wrote:
>=D0=92 =D0=9F=D1=82=D0=BD, 19/02/2010 =D0=B2 14:14 +0100, Jan Engelhar=
dt =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> On Friday 2010-02-19 12:52, Peter Volkov wrote:
>> For ip6table_rawpost, we could probably do this in the Kbuild file:
>>=20
>> ifneq (${CONFIG_IPV6},)
>> obj-${build_RAWNAT} +=3D ip6table_rawpost.o
>> endif
>>=20
>> Can you test?
>
>Works.
>
>> For the second patch, I would suggest to move around the structures =
in=20
>> rawnat_tg_reg to reduce the number of #ifdefs needed.
>
>Done. Updated patch in attachment.

Too late, I already merged it manually this morning :p (there was a=20
reply to your mail)

>Also added #ifdefs around ip6t MODULE_ALIAS.
>
>Also I've updated SYSRQ patch a bit. Added ifdefs around another IPV6
>related code and around MODULE_ALIAS.

I don't think we need to do it to such extremes - after all one of the=20
goals was to have less #macros than pom-ng.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
