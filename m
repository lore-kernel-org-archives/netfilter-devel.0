From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 19:52:40 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181940030.18003@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>  <4D35BCC7.90805@trash.net>  <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr> <1295375875.3290.38.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44867 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1ARSwl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:52:41 -0500
In-Reply-To: <1295375875.3290.38.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-01-18 19:37, Eric Dumazet wrote:

>Le mardi 18 janvier 2011 =C3=A0 19:21 +0100, Jan Engelhardt a =C3=A9cr=
it :
>>
>>I'll try to add to my case then; The dependency on case-sensitivity i=
s=20
>>a long-known issue, so much that in fact, Bart avoided doing this=20
>>again as early as ebtables's inception around 2002.
>
>Why not renaming only clashing files, and make sure future files are=20
>lowercase only ?

I did not think of it as a big deal; renames of non-conflicting files=20
was trivial low-hanging fruit. So might as well do it across the board=20
to get it into order.

It also happens to serve to not encourage users to continue using=20
uppercase on new submissions (since they are, at times, copy-and-paste=20
happy - we have seen that in the userspace code even more often than in=
=20
the kernel in the past - and don't read git logs or mailing lists to ge=
t=20
to know current practices).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
