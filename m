From: Andreas Herz <andi@geekosphere.org>
Subject: [PATCH iptables] fix wrong headername in ipv6header for protocols
Date: Thu, 16 Jul 2015 15:54:19 +0200
Message-ID: <1437054859-15824-1-git-send-email-andi@geekosphere.org>
Cc: Andreas Herz <andi@geekosphere.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:43472 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbbGPOBd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 10:01:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the --help output and manpage for ipv6header the name for upper layer
protocol headers was "proto", while in the code itself it's "prot" for
the short form. Fixed by changing manpage and help output.

Signed-off-by: Andreas Herz <andi@geekosphere.org>
---
 extensions/libip6t_ipv6header.c   | 2 +-
 extensions/libip6t_ipv6header.man | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 00d5d5b..6f03087 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -127,7 +127,7 @@ static void ipv6header_help(void)
 	printf(
 "ipv6header match options:\n"
 "[!] --header headers     Type of header to match, by name\n"
-"                         names: hop,dst,route,frag,auth,esp,none,proto\n"
+"                         names: hop,dst,route,frag,auth,esp,none,prot\n"
 "                    long names: hop-by-hop,ipv6-opts,ipv6-route,\n"
 "                                ipv6-frag,ah,esp,ipv6-nonxt,protocol\n"
 "                       numbers: 0,60,43,44,51,50,59\n"
diff --git a/extensions/libip6t_ipv6header.man b/extensions/libip6t_ipv6header.man
index a998861..807d9ab 100644
--- a/extensions/libip6t_ipv6header.man
+++ b/extensions/libip6t_ipv6header.man
@@ -31,7 +31,7 @@ Encapsulating Security Payload header
 No Next header which matches 59 in the 'Next Header field' of IPv6 header or
 any IPv6 extension headers
 .TP
-\fBproto\fP
+\fBprot\fP
 which matches any upper layer protocol header. A protocol name from
 /etc/protocols and numeric value also allowed. The number 255 is equivalent to
-\fBproto\fP.
+\fBprot\fP.
-- 
2.3.6

