From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/06]: x_tables: don't use __copy_{from,
	to}_user on unchecked memory in compat layer
Date: Tue,  2 May 2006 22:48:10 +0200 (MEST)
Message-ID: <20060502204810.7610.43060.sendpatchset@localhost.localdomain>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: don't use __copy_{from,to}_user on unchecked memory in compat layer

Noticed by Linus Torvalds <torvalds@osdl.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c0a6597ffa6dce9261565319327fa9d060ee8740
tree de902d88c478f87a15325f805f4325100514a5d7
parent b29ae226e0f4b00546194dae9263928e1abae468
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 22:28:08 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 22:28:08 +0200

 net/ipv4/netfilter/ip_tables.c |    6 +++---
 net/netfilter/x_tables.c       |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6d1c115..cee3397 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1441,7 +1441,7 @@ static int compat_copy_entry_to_user(str
 	ret = -EFAULT;
 	origsize = *size;
 	ce = (struct compat_ipt_entry __user *)*dstptr;
-	if (__copy_to_user(ce, e, sizeof(struct ipt_entry)))
+	if (copy_to_user(ce, e, sizeof(struct ipt_entry)))
 		goto out;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
@@ -1459,9 +1459,9 @@ static int compat_copy_entry_to_user(str
 		goto out;
 	ret = -EFAULT;
 	next_offset = e->next_offset - (origsize - *size);
-	if (__put_user(target_offset, &ce->target_offset))
+	if (put_user(target_offset, &ce->target_offset))
 		goto out;
-	if (__put_user(next_offset, &ce->next_offset))
+	if (put_user(next_offset, &ce->next_offset))
 		goto out;
 	return 0;
 out:
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 17abf60..99293c6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -289,7 +289,7 @@ int xt_compat_match(void *match, void **
 		case COMPAT_TO_USER:
 			pm = (struct xt_entry_match *)match;
 			msize = pm->u.user.match_size;
-			if (__copy_to_user(*dstptr, pm, msize)) {
+			if (copy_to_user(*dstptr, pm, msize)) {
 				ret = -EFAULT;
 				break;
 			}
@@ -366,7 +366,7 @@ int xt_compat_target(void *target, void 
 		case COMPAT_TO_USER:
 			pt = (struct xt_entry_target *)target;
 			tsize = pt->u.user.target_size;
-			if (__copy_to_user(*dstptr, pt, tsize)) {
+			if (copy_to_user(*dstptr, pt, tsize)) {
 				ret = -EFAULT;
 				break;
 			}
