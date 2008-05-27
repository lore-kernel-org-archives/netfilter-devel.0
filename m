From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Tue, 27 May 2008 09:11:34 +0200
Message-ID: <x6skw443x5@gzp>
References: <483AB493.6010503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:56839 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbYE0HpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 03:45:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net>:

|     iptables version 1.4.1-rc2

[kernel]
Linux gzp1 2.4.36.4-gzp1 #1 SMP Fri May 9 17:21:19 CEST 2008 i686
GNU/Linux

[glibc]
GNU C Library stable release version 2.3.6, by Roland McGrath et al.
Compiled by GNU CC version 4.1.2.
Compiled on a Linux 2.4.34-gzp1 system on 2007-04-04.

[gcc]
gcc (GCC) 4.2.4

[binutils]
GNU ld (Linux/GNU Binutils) 2.18.50.0.7.20080502

  CC       libxt_connlimit.oo
In file included from /usr/include/linux/netfilter_ipv4.h:9,
                 from ../include/linux/netfilter_ipv4/ip_tables.h:18,
                 from ../include/libiptc/libiptc.h:7,
                 from ../include/iptables.h:5,
                 from libxt_connlimit.c:8:
../include/linux/netfilter.h:41: error: expected specifier-qualifier-list before '__be32'
make[2]: *** [libxt_connlimit.oo] Error 1
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2'
make: *** [all] Error 2
