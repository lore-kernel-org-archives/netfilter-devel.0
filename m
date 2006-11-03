From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: nf_nat: work around crash in
	nf_conntrack_alter_reply
Date: Fri,  3 Nov 2006 17:46:30 +0100 (MET)
Message-ID: <20061103164843.15103.48547.sendpatchset@localhost.localdomain>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
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

nf_conntrack_alter_reply crashes if no helper is present. Disable
helper assignment since it doesn't work with the current conntrack
allocation scheme anyway.

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1f1c257..31a4472 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -855,7 +855,7 @@ void nf_conntrack_alter_reply(struct nf_
 	NF_CT_DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master && help->expecting == 0)
+	if (!conntrack->master && 0 && help->expecting == 0)
 		help->helper = __nf_ct_helper_find(newreply);
 	write_unlock_bh(&nf_conntrack_lock);
 }
