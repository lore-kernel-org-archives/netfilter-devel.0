From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] iptables 1.4.15 release
Date: Fri, 3 Aug 2012 10:59:07 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208031058350.23793@frira.zrqbmnf.qr>
References: <20120731112531.GA3493@1984> <201208030820.40088.arekm@maven.pl> <20120803084634.GA9363@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:59646 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2HCI7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:59:08 -0400
In-Reply-To: <20120803084634.GA9363@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-08-03 10:46, Pablo Neira Ayuso wrote:

>On Fri, Aug 03, 2012 at 08:20:39AM +0200, Arkadiusz Mi=C5=9Bkiewicz wr=
ote:
>> On Tuesday 31 of July 2012, Pablo Neira Ayuso wrote:
>> > Hi!
>> >=20
>> > The Netfilter project proudly presents:
>> >=20
>> >         iptables 1.4.15
>> >=20
>> > This release includes support for new features now present in the
>> > Linux kernel 3.5 and one major bugfix (that shows up with gcc-4.7)=
=2E
>>=20
>> Hm but 3.5 doesn't contain ip_queue.h anymore:
>>=20
>> In file included from libipq.c:34:0:
>> ../include/libipq/libipq.h:33:43: fatal error:=20
>> linux/netfilter_ipv4/ip_queue.h: No such file or directory
>
>That doesn't necessarily means we have to remove libipq from the tree.

Or you can just  ./configure --disable-libipq :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
