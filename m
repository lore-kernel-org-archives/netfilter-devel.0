From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sat, 02 Jun 2007 14:54:23 +0200
Message-ID: <4661687F.6040302@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>	<46431C0D.5080507@trash.net>	<Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr>	<464325EA.8040303@trash.net>	<Pine.LNX.4.61.0705101605020.32349@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0705292336050.11140@yvahk01.tjqt.qr> <465CA950.403@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080605000103040809050200"
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Dmitry Mishin <dim@openvz.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <465CA950.403@trash.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080605000103040809050200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Jan Engelhardt wrote:
> 
>>This is fixed in 2.6.21, thanks.
> 
> 
> 
> Yes, the hashlimit compat issue is. But the underlying problem still
> persists, I'll send you a patch for testing soon.


Here it is, could you please test whether it fixes the crash by
backing out the hashlimit compat patch and triggering the size
error again? Thanks.



--------------080605000103040809050200
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
commit aea9d0eb2c80de9d31a9ecbcaf5e529b7503ea13
tree f014a00779dc3c3745e3294a393941ab91c3d37e
parent e7d815ef75f70dcdf55001f1f88ae7ae8827a7ba
author Patrick McHardy <kaber@trash.net> Sat, 02 Jun 2007 14:51:13 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 02 Jun 2007 14:51:13 +0200

 net/ipv4/netfilter/ip_tables.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e3f83bf..8fde1d1 100644
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
@@ -1449,6 +1449,16 @@ compat_check_calc_match(struct ipt_entry_match *m,
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
 check_compat_entry_size_and_hooks(struct ipt_entry *e,
 			   struct xt_table_info *newinfo,
 			   unsigned int *size,
@@ -1485,10 +1495,10 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
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
@@ -1499,7 +1509,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 							t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
+		goto release_matches;
 	}
 	t->u.kernel.target = target;
 
@@ -1526,8 +1536,8 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 
 out:
 	module_put(t->u.kernel.target->me);
-cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+release_matches:
+	IPT_MATCH_ITERATE(e, compat_release_match, &j);
 	return ret;
 }
 

--------------080605000103040809050200--
