From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Wed, 2 Jan 2013 09:42:37 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301020821230.16620@nerf07.vanv.qr>
References: <201212301951.47241.vapier@gentoo.org> <1356933246-20336-1-git-send-email-jengelh@inai.de> <201301012303.52249.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57358 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3ABImk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 03:42:40 -0500
In-Reply-To: <201301012303.52249.vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-01-02 05:03, Mike Frysinger wrote:

>On Monday 31 December 2012 00:54:06 Jan Engelhardt wrote:
>> Like this? We cannot really get rid of mentioning .libs without involving
>> libltdl, and there I really do not want to go.
>
>why ?  are the modules run directly out of the build tree,

Yes, one can run them out of the build tree; by using
./configure --with-xtlibdir=$PWD/extensions

>> +	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@;
>
>i'm not sure why a lot of these rules have trailing semi-colons.  they're 
>pointless.

Hm must be a habit of doing other programming languages.

>> +	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link
>> ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< -L../libxtables
>> -lxtables ${$*_LIBADD} -rpath ${xtlibdir};
>
>should be ../libxtables/libxtables.la rather than -L/-l for libxtables
>
>>  libxt_NOTRACK.so: libxt_CT.so
>>  	ln -fs $< $@
>> libxt_state.so: libxt_conntrack.so
>>  	ln -fs $< $@
>
>these two rules could use your new $AM_VERBOSE_NULL
>
>otherwise, this is an improvement imo over the existing code
>-mike
>
