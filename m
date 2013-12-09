From: Hani Benhabiles <kroosec@gmail.com>
Subject: [PATCH iptables] libxtables: Call ipaddr_to_network before
 ipaddr_to_host.
Date: Mon, 9 Dec 2013 21:02:23 +0100
Message-ID: <20131209200223.GC2970@Inspiron-3521>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:37794 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LIUCj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:02:39 -0500
Received: by mail-we0-f180.google.com with SMTP id t61so3956622wes.39
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Dec 2013 12:02:38 -0800 (PST)
Received: from Inspiron-3521 ([41.103.24.16])
        by mx.google.com with ESMTPSA id bk7sm27800524wib.10.2013.12.09.12.02.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 09 Dec 2013 12:02:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Call ipaddr_to_network before ipaddr_to_host.

This saves waiting for a reverse DNS lookup query when the entry is present in
/etc/networks. This also follows the same order as in rules creation.

Signed-off-by: Hani Benhabiles <kroosec@gmail.com>
---
 libxtables/xtables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index fb60c01..bb25262 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1207,8 +1207,8 @@ const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
 {
 	const char *name;
 
-	if ((name = ipaddr_to_host(addr)) != NULL ||
-	    (name = ipaddr_to_network(addr)) != NULL)
+	if ((name = ipaddr_to_network(addr)) != NULL ||
+	    (name = ipaddr_to_host(addr)) != NULL)
 		return name;
 
 	return xtables_ipaddr_to_numeric(addr);
-- 
1.8.3.2

