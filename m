From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 39/50]: nf_conntrack_expect: introduce
	nf_conntrack_expect_max sysct
Date: Sat,  7 Jul 2007 14:23:55 +0200 (MEST)
Message-ID: <20070707122311.1589.64707.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_expect: introduce nf_conntrack_expect_max sysct

As a last step of preventing DoS by creating lots of expectations, this
patch introduces a global maximum and a sysctl to control it. The default
is initialized to 4 * the expectation hash table size, which results in
1/64 of the default maxmimum of conntracks.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7993e12c4d5d18b227a18402f5f4298f13a650ba
tree 417f1222632bb0fd06479bae480ae9f54775d6f4
parent 028150fd0c2a7b375bfdd0f2b4fd971edd422d19
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:58 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:58 +0200

 include/net/netfilter/nf_conntrack_expect.h |    1 +
 net/netfilter/nf_conntrack_expect.c         |   10 ++++++++++
 net/netfilter/nf_conntrack_standalone.c     |    9 ++++++++-
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 9d5af4e..cae1a0d 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -8,6 +8,7 @@
 
 extern struct hlist_head *nf_ct_expect_hash;
 extern unsigned int nf_ct_expect_hsize;
+extern unsigned int nf_ct_expect_max;
 
 struct nf_conntrack_expect
 {
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 5ef0dd4..513828f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -35,6 +35,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
 
 static unsigned int nf_ct_expect_hash_rnd __read_mostly;
 static unsigned int nf_ct_expect_count;
+unsigned int nf_ct_expect_max __read_mostly;
 static int nf_ct_expect_hash_rnd_initted __read_mostly;
 static int nf_ct_expect_vmalloc;
 
@@ -367,6 +368,14 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	    master_help->expecting >= master_help->helper->max_expected)
 		evict_oldest_expect(master);
 
+	if (nf_ct_expect_count >= nf_ct_expect_max) {
+		if (net_ratelimit())
+			printk(KERN_WARNING
+			       "nf_conntrack: expectation table full");
+		ret = -EMFILE;
+		goto out;
+	}
+
 	nf_ct_expect_insert(expect);
 	nf_ct_expect_event(IPEXP_NEW, expect);
 	ret = 0;
@@ -522,6 +531,7 @@ int __init nf_conntrack_expect_init(void)
 		if (!nf_ct_expect_hsize)
 			nf_ct_expect_hsize = 1;
 	}
+	nf_ct_expect_max = nf_ct_expect_hsize * 4;
 
 	nf_ct_expect_hash = nf_ct_alloc_hashtable(&nf_ct_expect_hsize,
 						  &nf_ct_expect_vmalloc);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 098e799..6af96c6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -372,7 +372,14 @@ static ctl_table nf_ct_sysctl_table[] = {
 		.extra1		= &log_invalid_proto_min,
 		.extra2		= &log_invalid_proto_max,
 	},
-
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nf_conntrack_expect_max",
+		.data		= &nf_ct_expect_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 	{ .ctl_name = 0 }
 };
 
