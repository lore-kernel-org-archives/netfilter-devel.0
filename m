From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 11/18] libnftables: move iface_cache_release to deinit
Date: Sat, 19 Aug 2017 17:24:13 +0200
Message-ID: <20170819152420.22563-12-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33826 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdHSPdM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:33:12 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnftables.c | 1 +
 src/main.c        | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 19d539c..2228156 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -50,6 +50,7 @@ void nft_global_init(void)
 
 void nft_global_deinit(void)
 {
+	iface_cache_release();
 	ct_label_table_exit();
 	realm_table_rt_exit();
 	devgroup_table_exit();
diff --git a/src/main.c b/src/main.c
index 2cb7e6f..08d77d0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -307,7 +307,6 @@ int main(int argc, char * const *argv)
 
 out:
 	xfree(buf);
-	iface_cache_release();
 	nft_context_free(nft);
 	nft_global_deinit();
 
-- 
2.14.1

