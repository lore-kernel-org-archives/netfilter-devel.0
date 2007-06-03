From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sun, 03 Jun 2007 18:57:13 +0200
Message-ID: <4662F2E9.1090903@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr> <465CA950.403@trash.net> <4661687F.6040302@trash.net> <200706031047.44848.dim@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040708030600030504080205"
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <200706031047.44848.dim@openvz.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040708030600030504080205
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Dmitry Mishin wrote:
> On Saturday 02 June 2007 16:54, Patrick McHardy wrote:
> 
>>Here it is, could you please test whether it fixes the crash by
>>backing out the hashlimit compat patch and triggering the size
>>error again? Thanks.
> 
> Patrick, 
> it looks like translate_compat_table() should be fixed also.


You're right, thanks for catching this. This patch should be
better.


--------------040708030600030504080205
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ip_tables: fix compat related crash

check_compat_entry_size_and_hooks iterates over the matches and calls
compat_check_calc_match, which loads the match and calculates the
compat offsets, but unlike the non-compat version, doesn't call
->checkentry yet. On error however it calls cleanup_matches, which in
turn calls ->destroy, which can result in crashes if the destroy
function (validly) expects to only get called after the checkentry
function.

Add a compat_release_match function that only drops the module reference
on error and rename compat_check_calc_match to compat_find_calc_match to
reflect the fact that it doesn't call the checkentry function.

Reported by Jan Engelhardt <jengelh@linux01.gwdg.de>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b2b15a77343e2baadee22a5e64f691732874b10b
tree 7d82cf0a9fd3cf77933205a7a1834e958293e293
parent e7d815ef75f70dcdf55001f1f88ae7ae8827a7ba
author Patrick McHardy <kaber@trash.net> Sun, 03 Jun 2007 18:57:04 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 03 Jun 2007 18:57:04 +0200

 net/ipv4/netfilter/ip_tables.c |   41 ++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e3f83bf..0a35639 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1425,7 +1425,7 @@ out:
 }
 
 static inline int
-compat_check_calc_match(struct ipt_entry_match *m,
+compat_find_calc_match(struct ipt_entry_match *m,
 	    const char *name,
 	    const struct ipt_ip *ip,
 	    unsigned int hookmask,
@@ -1449,6 +1449,31 @@ compat_check_calc_match(struct ipt_entry_match *m,
 }
 
 static inline int
+compat_release_match(struct ipt_entry_match *m, unsigned int *i)
+{
+	if (i && (*i)-- == 0)
+		return 1;
+
+	module_put(m->u.kernel.match->me);
+	return 0;
+}
+
+static inline int
+compat_release_entry(struct ipt_entry *e, unsigned int *i)
+{
+	struct ipt_entry_target *t;
+
+	if (i && (*i)-- == 0)
+		return 1;
+
+	/* Cleanup all matches */
+	IPT_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = ipt_get_target(e);
+	module_put(t->u.kernel.target->me);
+	return 0;
+}
+
+static inline int
 check_compat_entry_size_and_hooks(struct ipt_entry *e,
 			   struct xt_table_info *newinfo,
 			   unsigned int *size,
@@ -1485,10 +1510,10 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	off = 0;
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, compat_check_calc_match, name, &e->ip,
+	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
 			e->comefrom, &off, &j);
 	if (ret != 0)
-		goto cleanup_matches;
+		goto release_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
@@ -1499,7 +1524,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 							t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
+		goto release_matches;
 	}
 	t->u.kernel.target = target;
 
@@ -1526,8 +1551,8 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 
 out:
 	module_put(t->u.kernel.target->me);
-cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+release_matches:
+	IPT_MATCH_ITERATE(e, compat_release_match, &j);
 	return ret;
 }
 
@@ -1690,13 +1715,13 @@ translate_compat_table(const char *name,
 
 free_newinfo:
 	xt_free_table_info(newinfo);
-out:
 	IPT_ENTRY_ITERATE(entry0, total_size, cleanup_entry, &j);
 	return ret;
 out_unlock:
 	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
-	goto out;
+	IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	return ret;
 }
 
 static int

--------------040708030600030504080205--
