From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: unique function names in modules
Date: Sat, 20 Oct 2007 14:16:20 +0200
Message-ID: <4719F194.9070300@balabit.hu>
References: <4719CC82.6020205@balabit.hu> <Pine.LNX.4.64.0710201212250.1997@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:42525 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbXJTMQZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:16:25 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 87D92C1253
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 14:16:23 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710201212250.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt =EDrta:
> On Oct 20 2007 11:38, Laszlo Attila Toth wrote:
>> In kernel v2.6.23 the function names in the netfilter modules are no=
t unique.
>> Is it changed anywhere later? If not, I'll send patches for this (cu=
rrently I'm
>> working on it).
>=20
> I already have it done.
>=20
>=20

Ok, but where can I find these changes?
In davem/net-2.6 : net/netfilter/xt_mark.c the match/checkentry=20
functions have the old names...

--
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
