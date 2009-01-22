From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Ulogd patch series
Date: Thu, 22 Jan 2009 20:49:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901222048360.7246@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr> <1232630176.27232.2.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60615 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZAVTt4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:49:56 -0500
In-Reply-To: <1232630176.27232.2.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-22 14:16, Eric Leblond wrote:
>Le mardi 20 janvier 2009 =C3=A0 12:16 +0100, Jan Engelhardt a =C3=A9cr=
it :
>>=20
>> here are a bunch of patches that seemed to come in handy whilst=20
>> packaging ulogd as rpm.
>>=20
>> Please pull from
>> 	git://dev.medozas.de/ulogd master
>>=20
>> to recieve:
>> Jan Engelhardt (5):
>>       build: compile fix
>
>This one seems to be linked with your distro but the fix is harmless s=
o
>I've applied it.

Well, one should not really rely on some other header file
including it for you. Such is always a great surprise on,
say, BSD, which seems to have much less inter-header
dependencies. (Though this I tried on glibc 2.9.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
