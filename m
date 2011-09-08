From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Thu, 8 Sep 2011 17:22:03 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109081716390.13219@frira.zrqbmnf.qr>
References: <4E68C314.3070709@dump-Storage.net>  <alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr> <1315494418.2456.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hiroshi KIHIRA <hiro@dump-Storage.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51537 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1IHPWL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:22:11 -0400
In-Reply-To: <1315494418.2456.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-09-08 17:06, Eric Dumazet wrote:
>>=20
>> I am in favor of that. Though, I have to add, it actually misses the
>> inconsistency case {syntax is accepted, but the options are rejected
>> by the kernel}.
>>=20
>> What would probably be most desirable is that iptables-restore keeps
>> copies in memory of each table it attempted to touch,
>> for the eventual case of a rollback.
>
>Unfortunately, keeping a copy into userland memory is not enough to
>guarantee a rollback is possible in kernel land.
>
>You might be in an OOM situation preveting new (large) memory
>allocations.

If restoring the old table fails, no big deal, since we are already
in an inconsistent state anyway=C2=A0=E2=80=94 caused by the rejection =
of the new
table=C2=A0=E2=80=94, so there is no additional loss AFAICS.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
