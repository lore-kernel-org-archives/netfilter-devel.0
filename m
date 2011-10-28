From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] ipset: fix lookup of tcp port names
Date: Fri, 28 Oct 2011 18:16:13 +0200
Message-ID: <20111028181613.6702aeb7@s6510.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:47754 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab1J1QQU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:16:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The protocol argument to getservbyname() must be lowercase tcp not
uppercase TCP. This fixes the bug observed by:

 # ipset add foo http
 ipset v6.9.1: Syntax error: 'http' is invalid as number
 Syntax error: cannot parse 'http' as a TCP port
---
 lib/parse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/parse.c b/lib/parse.c
index 241d5ae..3ca702c 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -307,7 +307,7 @@ int
 ipset_parse_tcp_port(struct ipset_session *session,
 		     enum ipset_opt opt, const char *str)
 {
-	return ipset_parse_tcpudp_port(session, opt, str, "TCP");
+	return ipset_parse_tcpudp_port(session, opt, str, "tcp");
 }
 
 /**
@@ -330,7 +330,7 @@ ipset_parse_single_tcp_port(struct ipset_session *session,
 	assert(opt == IPSET_OPT_PORT || opt == IPSET_OPT_PORT_TO);
 	assert(str);
 
-	return ipset_parse_port(session, opt, str, "TCP");
+	return ipset_parse_port(session, opt, str, "tcp");
 }
 
 /**
-- 
1.7.2.5

