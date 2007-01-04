From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: compat offsets size change
Date: Thu,  4 Jan 2007 19:38:22 +0100 (MET)
Message-ID: <20070104183821.18369.7005.sendpatchset@localhost.localdomain>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
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

[NETFILTER]: compat offsets size change

Used by compat code offsets of entries should be 'unsigned int' as entries
array size has this dimension.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 50d2d72a7a584d3562c320c0d3a0f529c4c02e45
tree 8ce716848129163898c18ee1e206054f14c573d3
parent ef5db43a85df7269d22d6c1c38ceedc627c121e1
author Dmitry Mishin <dim@openvz.org> Thu, 04 Jan 2007 19:25:52 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 04 Jan 2007 19:25:52 +0100

 net/ipv4/netfilter/ip_tables.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

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
