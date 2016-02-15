From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/7] netfilter: fix IS_ERR_VALUE usage
Date: Mon, 15 Feb 2016 15:35:19 +0100
Message-ID: <1455546925-22119-2-git-send-email-a.hajda@samsung.com>
References: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

IS_ERR_VALUE should be used only with unsigned long type.
Otherwise it can work incorrectly. To achieve this function
xt_percpu_counter_alloc is modified to return unsigned long,
and its result is assigned to temporary variable to perform
error checking, before assigning to .pcnt field.

The patch follows conclusion from discussion on LKML [1][2].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2120927
[2]: http://permalink.gmane.org/gmane.linux.kernel/2150581

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 include/linux/netfilter/x_tables.h |  6 +++---
 net/ipv4/netfilter/arp_tables.c    | 11 +++++++----
 net/ipv4/netfilter/ip_tables.c     | 12 ++++++++----
 net/ipv6/netfilter/ip6_tables.c    | 13 +++++++++----
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c557741..79d4306 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -370,16 +370,16 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
  * allows us to return 0 for single core systems without forcing
  * callers to deal with SMP vs. NONSMP issues.
  */
-static inline u64 xt_percpu_counter_alloc(void)
+static inline unsigned long xt_percpu_counter_alloc(void)
 {
 	if (nr_cpu_ids > 1) {
 		void __percpu *res = __alloc_percpu(sizeof(struct xt_counters),
 						    sizeof(struct xt_counters));
 
 		if (res == NULL)
-			return (u64) -ENOMEM;
+			return -ENOMEM;
 
-		return (u64) (__force unsigned long) res;
+		return (__force unsigned long) res;
 	}
 
 	return 0;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b488cac..6dcc208 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -521,14 +521,16 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 	struct xt_entry_target *t;
 	struct xt_target *target;
 	int ret;
+	unsigned long pcnt;
 
 	ret = check_entry(e, name);
 	if (ret)
 		return ret;
 
-	e->counters.pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(e->counters.pcnt))
+	pcnt = xt_percpu_counter_alloc();
+	if (IS_ERR_VALUE(pcnt))
 		return -ENOMEM;
+	e->counters.pcnt = pcnt;
 
 	t = arpt_get_target(e);
 	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
@@ -1423,11 +1425,12 @@ static int translate_compat_table(const char *name,
 
 	i = 0;
 	xt_entry_foreach(iter1, entry1, newinfo->size) {
-		iter1->counters.pcnt = xt_percpu_counter_alloc();
-		if (IS_ERR_VALUE(iter1->counters.pcnt)) {
+		unsigned long pcnt = xt_percpu_counter_alloc();
+		if (IS_ERR_VALUE(pcnt)) {
 			ret = -ENOMEM;
 			break;
 		}
+		iter1->counters.pcnt = pcnt;
 
 		ret = check_target(iter1, name);
 		if (ret != 0) {
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b99affa..ad57c78 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -665,14 +665,16 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
+	unsigned long pcnt;
 
 	ret = check_entry(e, name);
 	if (ret)
 		return ret;
 
-	e->counters.pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(e->counters.pcnt))
+	pcnt = xt_percpu_counter_alloc();
+	if (IS_ERR_VALUE(pcnt))
 		return -ENOMEM;
+	e->counters.pcnt = pcnt;
 
 	j = 0;
 	mtpar.net	= net;
@@ -1609,10 +1611,12 @@ compat_check_entry(struct ipt_entry *e, struct net *net, const char *name)
 	struct xt_mtchk_param mtpar;
 	unsigned int j;
 	int ret = 0;
+	unsigned long pcnt;
 
-	e->counters.pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(e->counters.pcnt))
+	pcnt = xt_percpu_counter_alloc();
+	if (IS_ERR_VALUE(pcnt))
 		return -ENOMEM;
+	e->counters.pcnt = pcnt;
 
 	j = 0;
 	mtpar.net	= net;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 99425cf..4291c8d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -678,14 +678,16 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
+	unsigned long pcnt;
 
 	ret = check_entry(e, name);
 	if (ret)
 		return ret;
 
-	e->counters.pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(e->counters.pcnt))
+	pcnt = xt_percpu_counter_alloc();
+	if (IS_ERR_VALUE(pcnt))
 		return -ENOMEM;
+	e->counters.pcnt = pcnt;
 
 	j = 0;
 	mtpar.net	= net;
@@ -1619,10 +1621,13 @@ static int compat_check_entry(struct ip6t_entry *e, struct net *net,
 	int ret = 0;
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
+	unsigned long pcnt;
 
-	e->counters.pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(e->counters.pcnt))
+	pcnt = xt_percpu_counter_alloc();
+	if (IS_ERR_VALUE(pcnt))
 		return -ENOMEM;
+	e->counters.pcnt = pcnt;
+
 	j = 0;
 	mtpar.net	= net;
 	mtpar.table     = name;
-- 
1.9.1
