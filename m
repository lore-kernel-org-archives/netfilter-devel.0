From: holger@eitzenberger.org
Subject: [patch 2/4] ipset: make IPv4 and IPv6 address handling similar
Date: Tue, 18 Jan 2011 15:21:56 +0100
Message-ID: <20110118142247.498399684@eitzenberger.org>
References: <20110118142154.697547841@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline; filename=ipset-fix-ipv6-netmask-parsing.diff
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

While the following works for AF_INET:

 ipset add foo 192.168.1.1/32

this does not work for AF_INET6:

 ipset add foo6 20a1:1:2:3:4:5:6:7/128
 ipset v5.2: Syntax error: plain IP address must be supplied: 20a1:1:2:3:4:5:6:7/128
 
Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/lib/parse.c
===================================================================
--- ipset.orig/lib/parse.c	2011-01-14 11:14:41.000000000 +0100
+++ ipset/lib/parse.c	2011-01-14 11:15:06.000000000 +0100
@@ -960,9 +960,7 @@
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 	
-	return family == AF_INET ? ipset_parse_ip(session, opt, str)
-				 : ipset_parse_single_ip(session, opt, str);
-
+	return ipset_parse_ip(session, opt, str);
 }
 
 /**

-- 
