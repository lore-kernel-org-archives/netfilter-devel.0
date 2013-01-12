From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Sat, 12 Jan 2013 02:37:25 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301120236260.22170@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1301020821230.16620@nerf07.vanv.qr> <1357116471-27433-1-git-send-email-jengelh@inai.de> <20130111233430.GA18124@altlinux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: vapier@gentoo.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49882 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab3ALBhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:37:32 -0500
In-Reply-To: <20130111233430.GA18124@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2013-01-12 00:34, Dmitry V. Levin wrote:
>On Wed, Jan 02, 2013 at 09:47:51AM +0100, Jan Engelhardt wrote:
>[...]
>> --- a/extensions/GNUmakefile.in
>> +++ b/extensions/GNUmakefile.in
>[...]
>> @@ -75,7 +76,7 @@ install: ${targets_install}
>>  	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
>
>No, this is a regression.  If ${targets_install} shared objects are made
>by libtool, they are intermediate files not expected to be installed by
>Please also add -avoid-version along with -module, otherwise it produces
>(and --mode=install installs) useless symlinks.

Already posted patches for those -
http://marc.info/?l=netfilter-devel&m=135783093113355&w=2
