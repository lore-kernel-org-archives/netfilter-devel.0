From: =?UTF-8?B?SmnFmcOtIE1vcmF2ZWM=?= <jim.lkml@gmail.com>
Subject: iptables-1.4.2: libxt_TOS.c compilation ending with error - IPPROTO_SCTP
 redefined
Date: Wed, 22 Oct 2008 00:01:20 +0200
Message-ID: <48FE5130.1040609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.iwebs.cz ([78.156.136.15]:49253 "EHLO smtp2.iwebs.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYJUWBp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:01:45 -0400
Received: from [192.168.1.16] (unknown [78.156.136.66])
	by smtp2.iwebs.cz (Postfix) with ESMTP id B7A6E44A19B
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2008 16:57:58 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When I compiled iptables-1.4.2 I get an error:

In file included from /usr/include/netinet/ip.h:25,
                 from /usr/include/linux/ip.h:19,
                 from tos_values.c:4,
                 from libxt_TOS.c:15:
/usr/include/netinet/in.h:84: error: expected identifier before numeric constant
make[2]: *** [libxt_TOS.oo] Error 1



libxt_TOS.c:12
#include <xtables.h>
#include <linux/netfilter/xt_DSCP.h>
#include <linux/netfilter_ipv4/ipt_TOS.h>
#include "tos_values.c"

/usr/include/xtables.h:10
#ifndef IPPROTO_SCTP
#define IPPROTO_SCTP 132
#endif

/usr/include/netinet/in.h:84 (through tos_values.c -> linux/ip.h -> netinet/ip.h)
    IPPROTO_SCTP = 132,	   /* Stream Control Transmission Protocol.  */
#define IPPROTO_SCTP		IPPROTO_SCTP


On my gentoo box IPPROTO_SCTP is defined in /usr/include/netinet/in.h (from sys-libs/glibc-2.7 package)
and in /usr/include/xtables.h (net-firewall/iptables-1.4.1.1 package) too (conditionally).

However, in libxt_TOS.c <xtables.h> preceded <netinet/in.h> and SCTP is already defined by <xtables.h>.
So, definition in <netinet/in.h> ending with error, because line "IPPROTO_SCTP = 132", 
is probably interpreted as "132 = 132"


As a temporary workaround, I included <netinet/in.h> before <xtables.h>:
--- iptables-1.4.2/extensions/libxt_TOS.c.old   2008-10-21 20:06:18.334809888 +0200
+++ iptables-1.4.2/extensions/libxt_TOS.c       2008-10-21 20:06:47.774810167 +0200
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>

+#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_DSCP.h>
 #include <linux/netfilter_ipv4/ipt_TOS.h>
---

JiM
