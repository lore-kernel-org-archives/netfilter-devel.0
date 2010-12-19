From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 06:56:25 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012190643260.20608@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu> <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36326 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0LSF40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:56:26 -0500
In-Reply-To: <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-12-18 22:49, Jan Engelhardt wrote:
>On Saturday 2010-12-18 20:50, Jozsef Kadlecsik wrote:
>>>>>
>>>>> ./configure: line 11510: syntax error near unexpected token `[libmnl],'
>>>>> ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
>>>>> 
>>>>> CentOS' pkg-config is installed, so, for reference: I copied
>>>>> '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
>>>>> again and after that 'configure' had no problems.
>>>>
>>>>Autoconf has its own pitfalls... I can't reproduce it so I added
>>>>'aclocal -I m4' to autogen.sh.
>>> 
>>>That is not necessary, because we already have ACLOCAL_AMFLAGS = -I m4
>>>in Makefile.am.
>>
>>Yes, I know. Still I had a little hope that that'd fix the issue.
>>Do you have another idea? Should for example /usr/share/aclocal/pkg.m4 be 
>>unconditionally copied into m4/ by autogen.sh?
>
>autoreconf normally has /usr/share/aclocal in its search path,
>and I can say autoreconf does the job properly in CentOS 4.x.
>Ima gonna setup a centos5 vm..

I tried that now, and I see no problems relating to
PKG_CHECK_MODULES. Something looks flakey on the OP's machine.

What has been a problem in my test is that AC_PROG_GREP is not
known... I think I found a new height to RHEL obsolescence. RH5
(2007) ships autoconf 2.59 from Nov 2003.
