From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem
Date: Fri, 21 May 2010 21:17:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005212114400.11870@obet.zrqbmnf.qr>
References: <798212.56589.qm@web84206.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, adobriyan@gmail.com
To: - <d.stussy@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49384 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab0EUTRp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 15:17:45 -0400
In-Reply-To: <798212.56589.qm@web84206.mail.re3.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-05-21 21:14, - wrote:

>Did commit a79ff731a1b277d0e92d9453bdf374e04cec717a make it into the 2=
=2E6.34.0 kernel release?=C2=A0 It appears not to have, at least when I=
 looked at my source code archive....=C2=A0 The kernel is dated 2010-05=
-16, yet I did NOT see this patch in the changelog despite its April 13=
 date.

Indeed:

21:14 borg:~/code/linux > git describe=20
a79ff731a1b277d0e92d9453bdf374e04cec717a
v2.6.34-rc1-1132-ga79ff73

21:14 borg:~/code/linux > git describe --contains=20
a79ff731a1b277d0e92d9453bdf374e04cec717a
fatal: cannot describe 'a79ff731a1b277d0e92d9453bdf374e04cec717a'

21:16 borg:~/code/linux > git tag XHEAD kabernext/master
21:16 borg:~/code/linux > git describe --contains --match=3DXHEAD=20
a79ff731a1b277d0e92d9453bdf374e04cec717a
XHEAD~8^2~25

Looks indeed like something only in 2.6.35. Especially when doing the=20
much simpler

git show v2.6.34:include/linux/netfilter/x_tables.h

:-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
