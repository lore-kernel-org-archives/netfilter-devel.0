From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/22]: nfnetlink: parse attributes with nfattr_parse in
	nfnetlink_check_attribute
Date: Wed, 14 Mar 2007 09:50:50 +0100 (MET)
Message-ID: <20070314085034.15282.42384.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: parse attributes with nfattr_parse in nfnetlink_check_attribute

Use nfattr_parse to parse attributes, this patch also modifies the default 
behaviour since unknown attributes will be ignored instead of returning 
EINVAL. This ensure backward compatibility: new libraries with new 
attributes and old kernels can work.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 53d0099da1eea04b818399e4548daeb7399c7bc2
tree 20ef7dfae6763dabbc5b0a84a169e1c69db2f0c6
parent 95cddede9ae6fddfb993ab5d989f6d96cdf4e8e8
author Pablo Neira Ayuso <pablo@netfilter.org> Wed, 14 Mar 2007 09:35:23 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:35:23 +0100

 net/netfilter/nfnetlink.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9ba6aa4..dec36ab 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -151,26 +151,14 @@ nfnetlink_check_attributes(struct nfnetl
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
 	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
-	u_int16_t attr_count;
 	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-
-	attr_count = subsys->cb[cb_id].attr_count;
-	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
+	u_int16_t attr_count = subsys->cb[cb_id].attr_count;
 
 	/* check attribute lengths. */
 	if (likely(nlh->nlmsg_len > min_len)) {
 		struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
 		int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
-
-		while (NFA_OK(attr, attrlen)) {
-			unsigned flavor = NFA_TYPE(attr);
-			if (flavor) {
-				if (flavor > attr_count)
-					return -EINVAL;
-				cda[flavor - 1] = attr;
-			}
-			attr = NFA_NEXT(attr, attrlen);
-		}
+		nfattr_parse(cda, attr_count, attr, attrlen);
 	}
 
 	/* implicit: if nlmsg_len == min_len, we return 0, and an empty
