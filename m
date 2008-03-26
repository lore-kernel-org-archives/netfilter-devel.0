From: Max Kellermann <max@duempel.org>
Subject: [schepler@math.berkeley.edu: Bug#472812: conntrack: FTBFS with gcc-4.3 [amd64]: Large integer implicitly truncated to unsigned type]
Date: Wed, 26 Mar 2008 16:39:05 +0100
Message-ID: <20080326153905.GA28855@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:58512 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYCZP7Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:59:16 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

we just got this bug report on the conntrack-tools package.

Max


----- Forwarded message from Daniel Schepler <schepler@math.berkeley.edu> -----

From: Daniel Schepler <schepler@math.berkeley.edu>
To: submit@bugs.debian.org
Subject: Bug#472812: conntrack: FTBFS with gcc-4.3 [amd64]: Large integer implicitly truncated to unsigned type
X-Virus-Scanned: Debian amavisd-new at swift.blarg.de
X-Spam-Flag: NO
X-Spam-Score: -0.604
X-Spam-Level: 
X-Spam-Status: No, score=-0.604 required=5 tests=[BAYES_00=-3,
	MIME_QP_LONG_LINE=1.396, MY_DSL=1]
List-Owner: <mailto:netfilter-maintainers-owner@ned.snow-crash.org>
X-No-Auth: unauthenticated sender
Reply-To: Daniel Schepler <schepler@math.berkeley.edu>,
	472812@bugs.debian.org
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Date: Wed, 26 Mar 2008 15:21:10 +0000
X-Debian-PR-Source: conntrack
X-ORBL: [69.223.32.250]
Resent-Date: Wed, 26 Mar 2008 15:21:13 +0000
X-ned.snow-crash.org-MailScanner: Found to be clean, Found to be clean
X-ned.snow-crash.org-MailScanner-SpamCheck: not spam,	SpamAssassin (Wertung=-2.463, benoetigt 4.5, autolearn=not spam,	BAYES_00 -2.60, FORGED_RCVD_HELO 0.14, UNPARSEABLE_RELAY 0.00,	UPPERCASE_25_50 0.00), not spam (whitelisted),
	SpamAssassin (Wertung=-2.463, benoetigt 4.5, autolearn=not spam,
	BAYES_00 -2.60, FORGED_RCVD_HELO 0.14, UNPARSEABLE_RELAY 0.00,
	UPPERCASE_25_50 0.00)
X-MailScanner-From: netfilter-maintainers-bounce-16-a3fce6274147661a2e4ecde27c649a09@ned.snow-crash.org

Package: conntrack
Version: 1:0.9.6-2
Severity: important
User: tbm@cyrius.com
Usertags: ftbfs-gcc-4.3

>From my pbuilder build log on amd64, with gcc -> gcc-4.3:

...
Making all in src
make[2]: Entering directory `/tmp/buildd/conntrack-0.9.6/src'
x86_64-linux-gnu-gcc -DPACKAGE_NAME=\"conntrack-tools\" -DPACKAGE_TARNAME=\"conntrack-tools\" -DPACKAGE_VERSION=\"0.9.6\" -DPACKAGE_STRING=\"conntrack-tools\ 
0.9.6\" -DPACKAGE_BUGREPORT=\"pablo@netfilter.org\" -DPACKAGE=\"conntrack-tools\" -DVERSION=\"0.9.6\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -DYYTEXT_POINTER=1 -DHAVE_LINUX_CAPABILITY_H=1 -DHAVE_LIBNFNETLINK=1 -DHAVE_LIBNETFILTER_CONNTRACK=1 -DHAVE_ARPA_INET_H=1 -DHAVE_INET_PTON=1 -DHAVE_INET_PTON_IPV6=1 -I.  -I../include   -std=gnu99 -W -Wall -Werror -Wmissing-prototypes -Wwrite-strings -Wcast-qual -Wfloat-equal -Wshadow -Wpointer-arith -Wbad-function-cast -Wsign-compare -Waggregate-return -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wstrict-prototypes -Wundef -Wno-unused-parameter -g -O2 -fno-strict-ali
 asing   -c 
conntrack.c
cc1: warnings being treated as errors
conntrack.c: In function 'err2str':
conntrack.c:302: error: large integer implicitly truncated to unsigned type
make[2]: *** [conntrack.o] Error 1
make[2]: Leaving directory `/tmp/buildd/conntrack-0.9.6/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/tmp/buildd/conntrack-0.9.6'
make: *** [build-stamp] Error 2
dpkg-buildpackage: failure: debian/rules build gave error exit status 2
-- 
Daniel Schepler



--
To unsubscribe, send mail to netfilter-maintainers-unsubscribe@ned.snow-crash.org.

----- End forwarded message -----
