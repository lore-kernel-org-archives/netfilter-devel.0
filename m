From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: ebtables-2.0.10-1: a build problem
Date: Mon, 18 Jul 2011 19:03:40 +0200
Message-ID: <j01p1c$p9b$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56741 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1GRRDz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:03:55 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1QirEX-0004WT-Cg
	for netfilter-devel@vger.kernel.org; Mon, 18 Jul 2011 19:03:53 +0200
Received: from h75021.upc-h.chello.nl ([62.194.75.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2011 19:03:53 +0200
Received: from sfzhi by h75021.upc-h.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2011 19:03:53 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Just want to let you know that I've encountered a small problem while trying to build ebtables-2.0.10-1:

cc1: warnings being treated as errors
In file included from /usr/include/asm/sigcontext.h:5:0,
                  from /usr/include/bits/sigcontext.h:28,
                  from /usr/include/signal.h:339,
                  from ebtables.c:29:
include/linux/types.h:13:2: error: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
make: *** [ebtables.o] Error 1

The problem is that, even though "include/ebtables_u.h" defines __EXPORTED_HEADERS__ to prevent exactly this from happening, "include/linux/types.h" that throws the error is pulled in *before* that indirectly via "signal.h". (I'm using gcc-4.5.1, glibc-2.12.1, kernel headers 2.6.35.11.)

To be able to proceed with the build I had to remove "#define __EXPORTED_HEADERS__" from "include/ebtables_u.h" and "getethertype.c" and add "-D__EXPORTED_HEADERS__" to CFLAGS instead, although i"m not sure that was the best solution.

--
Regards,
Sergei.

