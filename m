From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: unique function names in modules
Date: Sat, 20 Oct 2007 14:23:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201423030.1997@fbirervta.pbzchgretzou.qr>
References: <4719CC82.6020205@balabit.hu> <Pine.LNX.4.64.0710201212250.1997@fbirervta.pbzchgretzou.qr>
 <4719F194.9070300@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46589 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765622AbXJTMX3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:23:29 -0400
In-Reply-To: <4719F194.9070300@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 20 2007 14:16, Laszlo Attila Toth wrote:
> Jan Engelhardt =C3=ADrta:
>> On Oct 20 2007 11:38, Laszlo Attila Toth wrote:
>> > In kernel v2.6.23 the function names in the netfilter modules are =
not
>> > unique.
>> > Is it changed anywhere later? If not, I'll send patches for this (=
currently
>> > I'm
>> > working on it).
>>=20
>> I already have it done.
>>=20
>>=20
>
> Ok, but where can I find these changes?
> In davem/net-2.6 : net/netfilter/xt_mark.c the match/checkentry funct=
ions have
> the old names...
>

Posted to nf-dev after me compile-testing. I am actually quite
lazy when it comes to sending patches - i rather stack em up.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
