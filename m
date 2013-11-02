From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH iptables] ip6tables: Use consistent exit code for EAGAIN
Date: Fri,  1 Nov 2013 21:08:34 -0700
Message-ID: <1383365314-12290-1-git-send-email-cernekee@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56473 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3KBEIo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Nov 2013 00:08:44 -0400
Received: by mail-pb0-f47.google.com with SMTP id rq13so967490pbb.6
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2013 21:08:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As of commit 056564f6a (Add new exit value to indicate concurrency
issues), the IPv4 iptables binary returns exit status 4 to indicate that
the kernel returned EAGAIN when trying to update a table.  But ip6tables
still returns exit status 1 under the same circumstances.  Update
ip6tables to bring it in line with iptables behavior.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 iptables/ip6tables-standalone.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 656e08d..4e20fe6 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -73,6 +73,9 @@ ip6tables_main(int argc, char *argv[])
 			fprintf(stderr, "ip6tables: %s.\n",
 				ip6tc_strerror(errno));
 		}
+		if (errno == EAGAIN) {
+			exit(RESOURCE_PROBLEM);
+		}
 	}
 
 	exit(!ret);
-- 
1.7.9.5

