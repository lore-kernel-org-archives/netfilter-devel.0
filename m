From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/20]: nf_conntrack: fix helper structure alignment
Date: Sat,  2 Dec 2006 15:49:41 +0100 (MET)
Message-ID: <20061202145245.1381.84739.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix helper structure alignment

Adding the alignment to the size doesn't make any sense, what it
should do is align the size of the conntrack structure to the
alignment requirements of the helper structure and return an
aligned pointer in nfct_help().

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fd155ea4144ef3b1d15705284b9513b42870e363
tree 9af3909df2ab29b89de1fe66ebd20b6d134728c0
parent 66d2cd318d32a8b3a876714f104477ba9aa6b87a
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:54 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:54 +0100

 include/net/netfilter/nf_conntrack.h |    1 +
 net/netfilter/nf_conntrack_helper.c  |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d0d0e64..b4beb8c 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -273,6 +273,7 @@ static inline struct nf_conn_help *nfct_
 	if (!(ct->features & NF_CT_F_HELP))
 		return NULL;
 
+	offset = ALIGN(offset, __alignof__(struct nf_conn_help));
 	return (struct nf_conn_help *) ((void *)ct + offset);
 }
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 03b3ed8..2628f4b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -97,13 +97,14 @@ static inline int unhelp(struct nf_connt
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	int ret;
+	int size, ret;
+
 	BUG_ON(me->timeout == 0);
 
+	size = ALIGN(sizeof(struct nf_conn), __alignof__(struct nf_conn_help)) +
+	       sizeof(struct nf_conn_help);
 	ret = nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
-					  sizeof(struct nf_conn)
-					  + sizeof(struct nf_conn_help)
-					  + __alignof__(struct nf_conn_help));
+					  size);
 	if (ret < 0) {
 		printk(KERN_ERR "nf_conntrack_helper_register: Unable to create slab cache for conntracks\n");
 		return ret;
