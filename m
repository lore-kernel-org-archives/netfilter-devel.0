From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/07]: Fix compat_xt_counters alignment for non-x86
Date: Fri, 21 Apr 2006 03:06:52 +0200 (MEST)
Message-ID: <20060421010652.8466.96856.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Fix compat_xt_counters alignment for non-x86

Some (?) non-x86 architectures require 8byte alignment for u_int64_t
even when compiled for 32bit, using u_int32_t in compat_xt_counters
breaks on these architectures, use u_int64_t for everything but x86.

Reported by Andreas Schwab <schwab@suse.de>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 030e806c1db0d3a278585b83475d1a6f9a874788
tree ef069a86e4ac0a1572ea51f7090b0e57df00052f
parent 40c6dcb49ac3f091e30fa105c347cc25776e8b72
author Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:19:29 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:19:29 +0200

 include/linux/netfilter/x_tables.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f6bdef8..3870145 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -361,7 +361,11 @@ struct compat_xt_entry_target
 
 struct compat_xt_counters
 {
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
 	u_int32_t cnt[4];
+#else
+	u_int64_t cnt[2];
+#endif
 };
 
 struct compat_xt_counters_info
