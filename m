From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: Addrtype match: renaming functions
Date: Thu, 04 Oct 2007 10:22:22 +0200
Message-ID: <4704A2BE.9090009@balabit.hu>
References: <4703b9ed.Kwc375N0W4hwnpA7%panther@balabit.hu> <47047355.30005@trash.net> <Pine.LNX.4.64.0710040805230.7253@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:40311 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXJDIW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:22:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id E3617C11B4
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 10:22:24 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710040805230.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt =EDrta:
> On Oct 4 2007 07:00, Patrick McHardy wrote:
>> Laszlo Attila Toth wrote:
>>> Hello,
>>>
>>> The function names in libipt_addrtype.c makes debugging hard, also =
I renamed them
>>> prefixed by 'addrtype_'.
>> Applied, thanks Laszlo.
>=20
> I went through changing all modules in this regard, patches coming la=
ter today
> when I finally woke up.
>=20

Hm, I wanted to do the same :) Could you remove the & chars too? Now it=
=20
  exists in some modules and doesn't in others.

--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
