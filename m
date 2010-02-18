From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons suggestions
Date: Thu, 18 Feb 2010 08:55:46 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002180854130.4022@obet.zrqbmnf.qr>
References: <20100216215128.1c154cdb@outerspace> <alpine.LSU.2.01.1002162057390.20293@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002162230430.29148@obet.zrqbmnf.qr> <20100218090110.74f6ce3e@outerspace>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44225 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0BRHzu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 02:55:50 -0500
In-Reply-To: <20100218090110.74f6ce3e@outerspace>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-18 08:01, Jonas Berlin wrote:

>> Well after all, libxtables_LIBS is currently never used.
(Oh well it is used)
>> (Extension modules don't link to it.)
>> So I cannot imagine linking problems, but that's the point
>> where you have to provide logs.
>
>Please find compilation output attached, the essential part being:
>
>make -f ../Makefile.iptrules all;
>make[3]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/extensions'
>  CC     libxt_CHAOS.oo
>  CCLD   libxt_CHAOS.so
>/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lxtables
>collect2: ld returned 1 exit status
>make[3]: *** [libxt_CHAOS.so] Error 1
>
>Seems to be this rule from Makefile.iptrules.in that is used:
>
>lib%.so: lib%.oo
>        ${AM_V_CCLD}${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< ${libxtables_LIBS} ${LDLIBS};

And you are able to make it link by overriding said libxtables_LIBS to 
your liking either at make time or (preferably) at configure time, as 
shown in the updated (in git) INSTALL file.
