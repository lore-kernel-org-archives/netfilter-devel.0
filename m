From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 39/39]: PPTP conntrack: fix another GRE keymap leak
Date: Wed, 20 Sep 2006 10:24:42 +0200 (MEST)
Message-ID: <20060920082533.14636.20420.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: fix another GRE keymap leak

When the master PPTP connection times out while still having unfullfilled
expectations (and a GRE keymap entry) associated with it, the keymap entry
is not destroyed.

Add a destroy callback to struct ip_conntrack_helper and use it to destroy
PPTP siblings when the master is destroyed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cdd7e9b9a5974273373402873c86f8a349b630d2
tree 18a8f3ed4912aaa4ae2311ff65a87e9238a72712
parent 0646fc2fe542b914d8d379c26f773854d9628815
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:07 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:07 +0200

 include/linux/netfilter_ipv4/ip_conntrack_helper.h |    2 ++
 net/ipv4/netfilter/ip_conntrack_core.c             |    5 +++++
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c      |   12 ++----------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_helper.h b/include/linux/netfilter_ipv4/ip_conntrack_helper.h
index 8d69279..77fe868 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_helper.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_helper.h
@@ -25,6 +25,8 @@ struct ip_conntrack_helper
 		    struct ip_conntrack *ct,
 		    enum ip_conntrack_info conntrackinfo);
 
+	void (*destroy)(struct ip_conntrack *ct);
+
 	int (*to_nfattr)(struct sk_buff *skb, const struct ip_conntrack *ct);
 };
 
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 2b6f24f..c432b31 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -307,6 +307,7 @@ destroy_conntrack(struct nf_conntrack *n
 {
 	struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
 	struct ip_conntrack_protocol *proto;
+	struct ip_conntrack_helper *helper;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
@@ -315,6 +316,10 @@ destroy_conntrack(struct nf_conntrack *n
 	ip_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
+	helper = ct->helper;
+	if (helper && helper->destroy)
+		helper->destroy(ct);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 98267b0..fb0aee6 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -553,15 +553,6 @@ conntrack_pptp_help(struct sk_buff **psk
 	nexthdr_off += tcph->doff * 4;
  	datalen = tcplen - tcph->doff * 4;
 
-	if (tcph->fin || tcph->rst) {
-		DEBUGP("RST/FIN received, timeouting GRE\n");
-		/* can't do this after real newnat */
-		info->cstate = PPTP_CALL_NONE;
-
-		/* untrack this call id, unexpect GRE packets */
-		pptp_destroy_siblings(ct);
-	}
-
 	pptph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_pptph), &_pptph);
 	if (!pptph) {
 		DEBUGP("no full PPTP header, can't track\n");
@@ -640,7 +631,8 @@ static struct ip_conntrack_helper pptp =
 			   .protonum = 0xff
 		 	 }
 		},
-	.help = conntrack_pptp_help
+	.help = conntrack_pptp_help,
+	.destroy = pptp_destroy_siblings,
 };
 
 extern void ip_ct_proto_gre_fini(void);
