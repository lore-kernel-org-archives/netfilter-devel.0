From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash with same name
Date: Tue, 22 Jul 2014 00:54:10 -0400
Message-ID: <1406004850-31336-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:60285 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbaGVFAC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:00:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Below is a first pass attempt at fixing a problem we've come across when
trying to do an iptables-restore where the hashlimit name stays the same, but
one of the hashlimit parameters changes but does not take affect.

For ex, if you have an existing hashlimit rule, do an iptables-save, change the
rate for that rule, and then do an iptables-restore the new rate will not be
enforced.

This appears to be due to a problem where hashlimit only checks for existing
hashes by name and family and does not consider any of the other config
parameters.

I've attempted to fix this by having it check for all hashlimit config params,
this way it doesn't accidentally match just on name. This brought up an issue
of having to make hashlimit aware of how many references there are to its
proc entry.

I'm not submitting this for inclusion yet, but for feedback. Mainly on the approach
and if there's possibly a better way of resolving this problem. My handling of
the proc "problem" is pretty messy right now and possibly incomplete, but the
patch below allows the case I described above to pass now. I hope to clean up
the proc handling in a v2.

Any feedback is greatly appreciated.

Thanks
Josh
---

    netfilter: xt_hashlimit: handle iptables-restore of hash with same name

    We encountered a problem when trying to do an iptables-restore of a ruleset
    which included a hashlimit match where the name stays the same and one of the
    other config parameters changed, for ex:

    from:
    -A INPUT -s 10.18.40.44/32 -i eth1 -p tcp -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10 --hashlimit-name test -j ACCEPT

    to:
    -A INPUT -s 10.18.40.44/32 -i eth1 -p tcp -m hashlimit --hashlimit-upto 1000/sec --hashlimit-burst 10 --hashlimit-name test -j ACCEPT

    Currently when we do do this the new parameters are not enforced.

    The problem stems from how htable_find_get() only checks by name and family.
    This causes htable_find_get() to return the old hash, instead of creating a
    new one.

    I've attempted to resolve this by having htable_find_get() check all config
    parameters b/f it returns a match. In addition, we have to keep the proc
    file around since it doesn't change b/c the hashes have the same name.

    Here's an example of the rules file:
        *filter
        :INPUT ACCEPT [1:1108]
        :FORWARD ACCEPT [0:0]
        :OUTPUT ACCEPT [0:0]
        -A INPUT -s 10.18.40.44/32 -i eth1 -p tcp -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10 --hashlimit-name test -j ACCEPT
        COMMIT

    Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/netfilter/xt_hashlimit.c |   87 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index a3910fc..5518018 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -215,6 +215,39 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
 }
 static void htable_gc(unsigned long htlong);
 
+static int htable_count_name(struct net *net,
+                             const char *name,
+                             u_int8_t family)
+{
+	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+	struct xt_hashlimit_htable *hinfo;
+	int count = 0;
+
+	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
+		if (!strcmp(name, hinfo->name) &&
+			family == hinfo->family) {
+			count++;
+		}
+	}
+	return count;
+}
+
+static struct proc_dir_entry *htable_get_pde(struct net *net,
+                                       const char *name,
+                                       u_int8_t family)
+{
+	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+	struct xt_hashlimit_htable *hinfo;
+
+	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
+		if (!strcmp(name, hinfo->name) &&
+			family == hinfo->family) {
+			return hinfo->pde;
+		}
+	}
+	return NULL;
+}
+
 static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 			 u_int8_t family)
 {
@@ -262,10 +295,13 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 	}
 	spin_lock_init(&hinfo->lock);
 
-	hinfo->pde = proc_create_data(minfo->name, 0,
-		(family == NFPROTO_IPV4) ?
-		hashlimit_net->ipt_hashlimit : hashlimit_net->ip6t_hashlimit,
-		&dl_file_ops, hinfo);
+	hinfo->pde = htable_get_pde(net, minfo->name, family);
+	if (hinfo->pde == NULL) {
+		hinfo->pde = proc_create_data(minfo->name, 0,
+			(family == NFPROTO_IPV4) ?
+			hashlimit_net->ipt_hashlimit : hashlimit_net->ip6t_hashlimit,
+			&dl_file_ops, hinfo);
+	}
 	if (hinfo->pde == NULL) {
 		kfree(hinfo->name);
 		vfree(hinfo);
@@ -339,25 +375,50 @@ static void htable_remove_proc_entry(struct xt_hashlimit_htable *hinfo)
 		remove_proc_entry(hinfo->name, parent);
 }
 
-static void htable_destroy(struct xt_hashlimit_htable *hinfo)
+static void htable_destroy(struct xt_hashlimit_htable *hinfo, bool remove_proc)
 {
 	del_timer_sync(&hinfo->timer);
-	htable_remove_proc_entry(hinfo);
+	if (remove_proc)
+		htable_remove_proc_entry(hinfo);
 	htable_selective_cleanup(hinfo, select_all);
 	kfree(hinfo->name);
 	vfree(hinfo);
 }
 
+static bool htable_compare(struct xt_hashlimit_mtinfo1 *info,
+				u_int8_t family,
+				struct xt_hashlimit_htable *hinfo)
+{
+	struct hashlimit_cfg1 newcfg = info->cfg;
+	struct hashlimit_cfg1 oldcfg = hinfo->cfg;
+
+	if (!strcmp(info->name, hinfo->name) &&
+		family == hinfo->family &&
+		newcfg.mode == oldcfg.mode &&
+		newcfg.avg == oldcfg.avg &&
+		newcfg.burst == oldcfg.burst &&
+		newcfg.size == oldcfg.size &&
+		newcfg.max == oldcfg.max &&
+		newcfg.gc_interval == oldcfg.gc_interval &&
+		newcfg.expire == oldcfg.expire &&
+		newcfg.srcmask == oldcfg.srcmask &&
+		newcfg.dstmask == oldcfg.dstmask ) {
+
+		return true;
+	}
+
+	return false;
+}
+
 static struct xt_hashlimit_htable *htable_find_get(struct net *net,
-						   const char *name,
+						   struct xt_hashlimit_mtinfo1 *info,
 						   u_int8_t family)
 {
 	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
 	struct xt_hashlimit_htable *hinfo;
 
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
-		if (!strcmp(name, hinfo->name) &&
-		    hinfo->family == family) {
+		if (htable_compare(info, family, hinfo)) {
 			hinfo->use++;
 			return hinfo;
 		}
@@ -367,10 +428,14 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 
 static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
+	bool remove_proc = false;
+
 	mutex_lock(&hashlimit_mutex);
 	if (--hinfo->use == 0) {
+		if (htable_count_name(hinfo->net, hinfo->name, hinfo->family) == 1)
+			remove_proc = true;
 		hlist_del(&hinfo->node);
-		htable_destroy(hinfo);
+		htable_destroy(hinfo, remove_proc);
 	}
 	mutex_unlock(&hashlimit_mutex);
 }
@@ -698,7 +763,7 @@ static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 	}
 
 	mutex_lock(&hashlimit_mutex);
-	info->hinfo = htable_find_get(net, info->name, par->family);
+	info->hinfo = htable_find_get(net, info, par->family);
 	if (info->hinfo == NULL) {
 		ret = htable_create(net, info, par->family);
 		if (ret < 0) {
-- 
1.7.9.5

