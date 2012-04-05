From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons compile error
Date: Thu, 5 Apr 2012 07:24:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204050724100.6040@frira.zrqbmnf.qr>
References: <4F7BB331.7000808@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45322 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2DEFYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:24:50 -0400
In-Reply-To: <4F7BB331.7000808@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-04-04 04:34, Mr Dash Four wrote:

>gcc -Wp,-MMD,./.libxt_DNETMAP.oo.d,-MT,libxt_DNETMAP.oo -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 	-D_REENTRANT -I../include -I/builddir/build/BUILD/xtables-addons-1.41/extensions -Wall -Waggregate-return -Wmissing-declarations 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes 	-Winline -pipe  -DPIC -fPIC  -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=pentium2 -fasynchronous-unwind-tables -o libxt_DNETMAP.oo -c libxt_DNETMAP.c;
>In file included from ../include/net/netfilter/nf_nat.h:5,
>                 from libxt_DNETMAP.c:15:
>../include/net/netfilter/nf_conntrack_tuple.h:29: error: redefinition of 'union nf_conntrack_man_proto'
>I am using/compiling against kernel version 3.3. With v3.2 that doesn't happen. Am I missing something?

This is resolved in the now-new xtables-addons 1.42.
