From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: xtables-addons compile error
Date: Wed, 04 Apr 2012 03:34:25 +0100
Message-ID: <4F7BB331.7000808@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60810 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2DDCeb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:34:31 -0400
Received: by wejx9 with SMTP id x9so206472wej.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Apr 2012 19:34:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

gcc -Wp,-MMD,./.libxt_DNETMAP.oo.d,-MT,libxt_DNETMAP.oo -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 	-D_REENTRANT -I../include -I/builddir/build/BUILD/xtables-addons-1.41/extensions -Wall -Waggregate-return -Wmissing-declarations 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes 	-Winline -pipe  -DPIC -fPIC  -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=pentium2 -fasynchronous-unwind-tables -o libxt_DNETMAP.oo -c libxt_DNETMAP.c;
In file included from ../include/net/netfilter/nf_nat.h:5,
                 from libxt_DNETMAP.c:15:
../include/net/netfilter/nf_conntrack_tuple.h:29: error: redefinition of 'union nf_conntrack_man_proto'
make[3]: *** [libxt_DNETMAP.oo] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: Leaving directory `/builddir/build/BUILD/xtables-addons-1.41/extensions'
make[2]: *** [user-all-local] Error 2
make[2]: Leaving directory `/builddir/build/BUILD/xtables-addons-1.41/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/builddir/build/BUILD/xtables-addons-1.41'
make: *** [all] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.FNo2bg (%build)

I am using/compiling against kernel version 3.3. With v3.2 that doesn't happen. Am I missing something?
