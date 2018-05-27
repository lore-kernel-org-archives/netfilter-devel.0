From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables-compat: homogenize error message
Date: Sun, 27 May 2018 18:39:01 +0530
Message-ID: <20180527130901.GA18320@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

There is a difference between error messages in iptables and
iptables-compat:

#sudo iptables-compat -D INPUT 4
iptables: No chain/target/match by that name.

#sudo iptables -D INPUT 4
iptables: Index of deletion too big.

Now, will show same error message.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e33d00f..40646f4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2603,7 +2603,7 @@ const char *nft_strerror(int err)
 	    { nft_rule_add, E2BIG, "Index of insertion too big" },
 	    { nft_rule_check, ENOENT, "Bad rule (does a matching rule exist in that chain?)" },
 	    { nft_rule_replace, ENOENT, "Index of replacement too big" },
-	    { nft_rule_delete_num, E2BIG, "Index of deletion too big" },
+	    { nft_rule_delete_num, ENOENT, "Index of deletion too big" },
 /*	    { TC_READ_COUNTER, E2BIG, "Index of counter too big" },
 	    { TC_ZERO_COUNTER, E2BIG, "Index of counter too big" }, */
 	    { nft_rule_add, ELOOP, "Loop found in table" },
-- 
2.7.4
