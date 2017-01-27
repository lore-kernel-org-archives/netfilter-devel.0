From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH conntrack-tools] conntrackd: cthelper: Don't leak nat_tuple
Date: Thu, 26 Jan 2017 16:44:24 -0800
Message-ID: <20170127004424.16494-1-cernekee@chromium.org>
Cc: ejcaruso@chromium.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35646 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbdA0AyR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 19:54:17 -0500
Received: by mail-pg0-f46.google.com with SMTP id 194so76557677pgd.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 16:53:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfexp_set_attr() copies |nat_tuple| rather than taking ownership, so
it should be freed at the end of the loop.  Some of the other helpers
(like rpc.c) do this, but it is missing here.

Reported-by: Eric Caruso <ejcaruso@chromium.org>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---


Compile-tested only.

I did apply the same change to my local UPnP/SSDP helper, and ran it
under valgrind to check for use-after-free errors.


 src/helpers/amanda.c | 1 +
 src/helpers/ftp.c    | 1 +
 src/helpers/tftp.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/src/helpers/amanda.c b/src/helpers/amanda.c
index 9e6c4e706d6d..faee1cd586fa 100644
--- a/src/helpers/amanda.c
+++ b/src/helpers/amanda.c
@@ -75,6 +75,7 @@ static int nat_amanda(struct pkt_buff *pkt, uint32_t ctinfo,
 			break;
 		}
 	}
+	nfct_destroy(nat_tuple);
 
 	if (port == 0) {
 		pr_debug("all ports in use\n");
diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 27ab5ebbb662..c3aa28485b0f 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -423,6 +423,7 @@ static unsigned int nf_nat_ftp(struct pkt_buff *pkt,
 			break;
 		}
 	}
+	nfct_destroy(nat_tuple);
 
 	if (port == 0)
 		return NF_DROP;
diff --git a/src/helpers/tftp.c b/src/helpers/tftp.c
index 45591c617e76..70dd28a5aa12 100644
--- a/src/helpers/tftp.c
+++ b/src/helpers/tftp.c
@@ -65,6 +65,7 @@ static unsigned int nat_tftp(struct pkt_buff *pkt, uint32_t ctinfo,
 	nfexp_set_attr_u32(exp, ATTR_EXP_NAT_DIR, MYCT_DIR_REPL);
 	nfexp_set_attr(exp, ATTR_EXP_FN, "nat-follow-master");
 	nfexp_set_attr(exp, ATTR_EXP_NAT_TUPLE, nat_tuple);
+	nfct_destroy(nat_tuple);
 
 	return NF_ACCEPT;
 }
-- 
2.11.0.483.g087da7b7c-goog

