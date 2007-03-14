From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/22]: nfnetlink: remove unrequired check in
	nfnetlink_get_subsys
Date: Wed, 14 Mar 2007 09:50:34 +0100 (MET)
Message-ID: <20070314085019.15282.80022.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: remove unrequired check in nfnetlink_get_subsys

subsys_table is initialized to NULL, therefore just returns NULL in case
that it is not set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bc5959a6bd9a56d1ea0e31344bde2b4f119d8b4c
tree 7c56a7256ee573e38f4a480dd7b8f6412e7e29bc
parent 6399e6156d65ce163cc77aeb6d53eacf9d9a1fb2
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 08 Mar 2007 18:25:37 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:31:09 +0100

 net/netfilter/nfnetlink.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9d33807..0b0a966 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -94,8 +94,7 @@ static inline struct nfnetlink_subsystem
 {
 	u_int8_t subsys_id = NFNL_SUBSYS_ID(type);
 
-	if (subsys_id >= NFNL_SUBSYS_COUNT
-	    || subsys_table[subsys_id] == NULL)
+	if (subsys_id >= NFNL_SUBSYS_COUNT)
 		return NULL;
 
 	return subsys_table[subsys_id];
