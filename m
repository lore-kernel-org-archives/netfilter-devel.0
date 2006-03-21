From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/09]: conntrack: cleanup the conntrack ID
	initialization
Date: Tue, 21 Mar 2006 02:55:54 +0100 (MET)
Message-ID: <20060321015554.11977.23846.sendpatchset@localhost.localdomain>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
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
commit b15cd1a2d0f3d67450b9738c071ec1fa74541305
tree 975cad31827b20e16f43e5c79ccaf29276c8fab5
parent 443b1bf80678fcd789ce5c984a3240108bec4736
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 20 Mar 2006 14:06:18 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 20 Mar 2006 14:06:18 +0100

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
index 29dfd0e..8dbca5d 100644
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
