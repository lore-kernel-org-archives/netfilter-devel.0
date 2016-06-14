From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] libipt_NETMAP: Avoid listing 32 bit mask and fix tests
Date: Wed, 15 Jun 2016 02:02:40 +0530
Message-ID: <20160614203240.GA23145@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36514 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcFNUdZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 16:33:25 -0400
Received: by mail-pf0-f195.google.com with SMTP id 62so71327pfd.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 13:33:25 -0700 (PDT)
Received: from shivani ([116.202.36.152])
        by smtp.gmail.com with ESMTPSA id f187sm47396341pfb.60.2016.06.14.13.33.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 14 Jun 2016 13:33:23 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(1) If subnet mask is unspecified with an IPv4 address, the rule
lists as

iptables -I PREROUTING -t nat -j NETMAP --to  to:1.2.3.4/32

Remove this and make the rule list as

iptables -I PREROUTING -t nat -j NETMAP --to  to:1.2.3.4

(2) Fix the tests for NETMAP for IPv4.

Before this patch,

ERROR: line 3 (cannot find: iptables -I PREROUTING -t nat -j NETMAP --to 1.2.3.0/24)
ERROR: line 4 (cannot find: iptables -I PREROUTING -t nat -j NETMAP --to 1.2.3.4)

After this patch, no errors with tests were observed.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_NETMAP.c | 2 +-
 extensions/libipt_NETMAP.t | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 4932c96..7c5d657 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -76,7 +76,7 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	bits = netmask2bits(a.s_addr);
 	if (bits < 0)
 		printf("/%s", xtables_ipaddr_to_numeric(&a));
-	else
+	else if (bits < 32)
 		printf("/%d", bits);
 }
 
diff --git a/extensions/libipt_NETMAP.t b/extensions/libipt_NETMAP.t
index 31924b9..de2bf8f 100644
--- a/extensions/libipt_NETMAP.t
+++ b/extensions/libipt_NETMAP.t
@@ -1,4 +1,4 @@
 :PREROUTING,INPUT,OUTPUT,POSTROUTING
 *nat
--j NETMAP --to 1.2.3.0/24;=;OK
--j NETMAP --to 1.2.3.4;=;OK
+-j NETMAP --to 1.2.3.0/24;-j NETMAP --to  to:1.2.3.0/24;OK
+-j NETMAP --to 1.2.3.4;-j NETMAP --to  to:1.2.3.4;OK
-- 
1.9.1

