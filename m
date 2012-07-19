From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ulogd - rpm file generation
Date: Fri, 20 Jul 2012 01:16:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207200100470.8460@frira.zrqbmnf.qr>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr>
 <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr> <50088FB0.4020403@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:60643 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2GSXQj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:16:39 -0400
In-Reply-To: <50088FB0.4020403@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-07-20 00:52, Mr Dash Four wrote:

>> ulogd depends on libnetfilter_acct, which in turn requires glibc >= 2.9, and
>> RHEL5 is just too damn old.
>>  
> Nope! If libnetfilter_acct is compiled from source

(Well, you can't compile it from anything else than source, so...)

> it does *not* require glibc >= 2.9

libnetfilter_acct.c: In function 'nfacct_nlmsg_build_payload':
libnetfilter_acct.c:348: warning: implicit declaration of function 'htobe64'

and htobe64(3) says htobe64 is available starting glibc-2.9.
Additionally,

../include/linux/netfilter/nfnetlink.h:4:46: error:
linux/netfilter/nfnetlink_compat.h: No such file or directory

so it also requires linux-glibc-devel >= 2.6.24, which RHEL5 also
does not have.

> and uses the version of glibc on the host system.

Who would have thought. There is no other glibc to use in the first place.


