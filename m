From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 2/3] ipset: Fix malformed output from list/save for ICMP types in port field.
Date: Thu, 07 Nov 2013 12:56:15 +0200
Message-ID: <2351390.3tInbbydSl@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp46.i.mail.ru ([94.100.177.106]:40941 "EHLO smtp46.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3KGLAS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:00:18 -0500
Received: from [2a01:6d80:103:13::c3ea:4404] (port=51650 helo=tuxracer.localnet)
	by smtp46.i.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1VeNJw-0003Ou-7O
	for netfilter-devel@vger.kernel.org; Thu, 07 Nov 2013 15:00:16 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Found with ipset 6.12.1, but upstream version is still affected.

Creating set of dimension three, adding elements to it and then
displaying gives following results:
-----------------------------------

 # ipset create test-1 hash:ip,port,ip
 # ipset add test-1 192.0.2.1,icmp:echo-request,192.0.2.1
 # ipset add test-1 192.0.2.1,icmp:ttl-zero-during-reassembly,192.0.2.1
 # ipset list test-1
 Name: test-1
 Type: hash:ip,port,ip
 Header: family inet hashsize 1024 maxelem 65536
 Size in memory: 16608
 References: 0
 Members:
 192.0.2.1,icmp:ttl-zero-during-reass,192.0.2.1
 192.0.2.1,icmp:echo-re,192.0.2.1

Same results with -output save|xml.

ipset_print_proto_port() from lib/print.c returns incorrect length
of printed string when ICMP/ICMPv6 specified in port field.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 lib/print.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/print.c b/lib/print.c
index abdfd34..6988fdf 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -709,18 +709,20 @@ ipset_print_proto_port(char *buf, unsigned int len,
 		case IPPROTO_UDPLITE:
 			break;
 		case IPPROTO_ICMP:
-			return ipset_print_icmp(buf + offset, len, data,
+			size = ipset_print_icmp(buf + offset, len, data,
 						IPSET_OPT_PORT, env);
+			goto out;
 		case IPPROTO_ICMPV6:
-			return ipset_print_icmpv6(buf + offset, len, data,
+			size = ipset_print_icmpv6(buf + offset, len, data,
 						  IPSET_OPT_PORT, env);
+			goto out;
 		default:
 			break;
 		}
 	}
 	size = ipset_print_port(buf + offset, len, data, IPSET_OPT_PORT, env);
+out:
 	SNPRINTF_FAILURE(size, len, offset);
-
 	return offset;
 }
 
-- 
1.7.10.4

