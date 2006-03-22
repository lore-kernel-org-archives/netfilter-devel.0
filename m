From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/10]: conntrack: cleanup the conntrack ID
	initialization
Date: Wed, 22 Mar 2006 19:47:49 +0100 (MET)
Message-ID: <20060322184749.5655.23532.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: cleanup the conntrack ID initialization

Currently the first conntrack ID assigned is 2, use 1 instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cd2e541eb6c94db1a40862885fd89ccae23dc7ac
tree a4dc84f7fb7fa53862b39d35735cc7432a42bffd
parent 0682fabed0e333d1d225c83f49878d220335ace9
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 21 Mar 2006 22:30:21 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:21 +0100

 net/ipv4/netfilter/ip_conntrack_core.c |    4 ++--
 net/netfilter/nf_conntrack_core.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 84c66db..9e34034 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -77,8 +77,8 @@ unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
-static unsigned int ip_conntrack_next_id = 1;
-static unsigned int ip_conntrack_expect_next_id = 1;
+static unsigned int ip_conntrack_next_id;
+static unsigned int ip_conntrack_expect_next_id;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 struct notifier_block *ip_conntrack_chain;
 struct notifier_block *ip_conntrack_expect_chain;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f649823..c288406 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -85,8 +85,8 @@ unsigned int nf_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc;
 
-static unsigned int nf_conntrack_next_id = 1;
-static unsigned int nf_conntrack_expect_next_id = 1;
+static unsigned int nf_conntrack_next_id;
+static unsigned int nf_conntrack_expect_next_id;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct notifier_block *nf_conntrack_chain;
 struct notifier_block *nf_conntrack_expect_chain;
