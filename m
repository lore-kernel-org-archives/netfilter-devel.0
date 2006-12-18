From: Dmitry Mishin <dim@openvz.org>
Subject: [PATCH] compat offsets size change
Date: Mon, 18 Dec 2006 19:35:09 +0300
Message-ID: <200612181935.09600.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Used by compat code offsets of entries should be 'unsigned int' as entries
array size has this dimension.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
---
 ip_tables.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 09696f1..fc1f153 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -919,13 +919,13 @@ copy_entries_to_user(unsigned int total_
 #ifdef CONFIG_COMPAT
 struct compat_delta {
 	struct compat_delta *next;
-	u_int16_t offset;
+	unsigned int offset;
 	short delta;
 };
 
 static struct compat_delta *compat_offsets = NULL;
 
-static int compat_add_offset(u_int16_t offset, short delta)
+static int compat_add_offset(unsigned int offset, short delta)
 {
 	struct compat_delta *tmp;
 
@@ -957,7 +957,7 @@ static void compat_flush_offsets(void)
 	}
 }
 
-static short compat_calc_jump(u_int16_t offset)
+static short compat_calc_jump(unsigned int offset)
 {
 	struct compat_delta *tmp;
 	short delta;
@@ -997,7 +997,7 @@ static int compat_calc_entry(struct ipt_
 		void *base, struct xt_table_info *newinfo)
 {
 	struct ipt_entry_target *t;
-	u_int16_t entry_offset;
+	unsigned int entry_offset;
 	int off, i, ret;
 
 	off = 0;
@@ -1467,7 +1467,7 @@ check_compat_entry_size_and_hooks(struct
 {
 	struct ipt_entry_target *t;
 	struct ipt_target *target;
-	u_int16_t entry_offset;
+	unsigned int entry_offset;
 	int ret, off, h, j;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
