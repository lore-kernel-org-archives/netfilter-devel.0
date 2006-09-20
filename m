From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/39]: make some netfilter globals __read_mostly
Date: Wed, 20 Sep 2006 10:24:12 +0200 (MEST)
Message-ID: <20060920082503.14636.27703.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: make some netfilter globals __read_mostly

Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 850a4981b57001c022d4b69a24d163404823ddb3
tree 2c28cff31a435bf021029b68b049fc8168592ff4
parent 21df1122e9ade53430f3c3a7e188ec194baedb93
author Brian Haley <brian.haley@hp.com> Wed, 20 Sep 2006 09:35:56 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:35:56 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    6 +++---
 net/ipv4/netfilter/ip_queue.c          |    8 ++++----
 net/ipv6/netfilter/ip6_queue.c         |    8 ++++----
 net/netfilter/nf_conntrack_core.c      |   10 +++++-----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 422a662..2b6f24f 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -63,17 +63,17 @@ atomic_t ip_conntrack_count = ATOMIC_INI
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
-struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO];
+struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO] __read_mostly;
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size __read_mostly = 0;
 int ip_conntrack_max __read_mostly;
-struct list_head *ip_conntrack_hash;
+struct list_head *ip_conntrack_hash __read_mostly;
 static kmem_cache_t *ip_conntrack_cachep __read_mostly;
 static kmem_cache_t *ip_conntrack_expect_cachep __read_mostly;
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid __read_mostly;
 static LIST_HEAD(unconfirmed);
-static int ip_conntrack_vmalloc;
+static int ip_conntrack_vmalloc __read_mostly;
 
 static unsigned int ip_conntrack_next_id;
 static unsigned int ip_conntrack_expect_next_id;
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 80060cb..7edad79 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -52,15 +52,15 @@ struct ipq_queue_entry {
 
 typedef int (*ipq_cmpfn)(struct ipq_queue_entry *, unsigned long);
 
-static unsigned char copy_mode = IPQ_COPY_NONE;
+static unsigned char copy_mode __read_mostly = IPQ_COPY_NONE;
 static unsigned int queue_maxlen __read_mostly = IPQ_QMAX_DEFAULT;
 static DEFINE_RWLOCK(queue_lock);
-static int peer_pid;
-static unsigned int copy_range;
+static int peer_pid __read_mostly;
+static unsigned int copy_range __read_mostly;
 static unsigned int queue_total;
 static unsigned int queue_dropped = 0;
 static unsigned int queue_user_dropped = 0;
-static struct sock *ipqnl;
+static struct sock *ipqnl __read_mostly;
 static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index d322e83..9510c24 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -56,15 +56,15 @@ struct ipq_queue_entry {
 
 typedef int (*ipq_cmpfn)(struct ipq_queue_entry *, unsigned long);
 
-static unsigned char copy_mode = IPQ_COPY_NONE;
+static unsigned char copy_mode __read_mostly = IPQ_COPY_NONE;
 static unsigned int queue_maxlen __read_mostly = IPQ_QMAX_DEFAULT;
 static DEFINE_RWLOCK(queue_lock);
-static int peer_pid;
-static unsigned int copy_range;
+static int peer_pid __read_mostly;
+static unsigned int copy_range __read_mostly;
 static unsigned int queue_total;
 static unsigned int queue_dropped = 0;
 static unsigned int queue_user_dropped = 0;
-static struct sock *ipqnl;
+static struct sock *ipqnl __read_mostly;
 static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index adeafa2..093b3dd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,17 +73,17 @@ atomic_t nf_conntrack_count = ATOMIC_INI
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
 LIST_HEAD(nf_conntrack_expect_list);
-struct nf_conntrack_protocol **nf_ct_protos[PF_MAX];
-struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX];
+struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
 static LIST_HEAD(helpers);
 unsigned int nf_conntrack_htable_size __read_mostly = 0;
 int nf_conntrack_max __read_mostly;
-struct list_head *nf_conntrack_hash;
-static kmem_cache_t *nf_conntrack_expect_cachep;
+struct list_head *nf_conntrack_hash __read_mostly;
+static kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
 struct nf_conn nf_conntrack_untracked;
 unsigned int nf_ct_log_invalid __read_mostly;
 static LIST_HEAD(unconfirmed);
-static int nf_conntrack_vmalloc;
+static int nf_conntrack_vmalloc __read_mostly;
 
 static unsigned int nf_conntrack_next_id;
 static unsigned int nf_conntrack_expect_next_id;
