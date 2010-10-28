From: Jyotiswarup Raiturkar <jyotisr5@googlemail.com>
Subject: Re: CONMARK and SNAT
Date: Thu, 28 Oct 2010 17:44:11 +0530
Message-ID: <AANLkTi=jc5vYd=MLZcHkbTeHoCZ3eNzXJwi9udP61Otr@mail.gmail.com>
References: <AANLkTin8DL4gEKmFoVwD=h6v=QOSKKneSAmg=YqHV8bN@mail.gmail.com>
	<AANLkTimxtJ+A1FTtiU1ubCx8u7LBPA54A9JhT9p0esep@mail.gmail.com>
	<alpine.LNX.2.01.1010281408410.26171@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab0J1MOM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:14:12 -0400
Received: by wwe15 with SMTP id 15so1970421wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2010 05:14:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010281408410.26171@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I can setup CONMARK with the IP address (IPMARK), as an integer
derived from the IPV4 address...So I was hoping to get the reverse :
set the IP source address based on the CONMARK ; with some interger to
IPV4 conversion

On Thu, Oct 28, 2010 at 5:39 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Thursday 2010-10-28 13:34, Jyotiswarup Raiturkar wrote:
>
>>Hello
>>
>>I want to setup a simple generic rule=A0 :
>>
>>If (connection has CONMARK =3D xx),=A0 than set TARGET as SNAT --to-s=
ource xx
>
> xx is an integer, but --to-source requires an IPv4 address instead, s=
o
> you cannot mix them.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
