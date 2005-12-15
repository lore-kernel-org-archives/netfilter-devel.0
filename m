From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Thu, 15 Dec 2005 20:16:55 +0100
Message-ID: <43A1C126.9020606@eurodev.net>
References: <439419A7.7040100@eurodev.net>	<200512090241.jB92fXDR003303@toshiba.co.jp>	<43A0C749.2050901@trash.net>
	<200512150224.jBF2O4Qf011205@toshiba.co.jp>
	<43A0D5C2.40000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000405090107040906000001"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43A0D5C2.40000@trash.net>
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

This is a multi-part message in MIME format.
--------------000405090107040906000001
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
> 
>> Well, I've found a issue. Current dumping code returns the
>> informations about
>> IPv6 connections regardless of the address family in nfctnetlink header
>> (nfgenmsg). As a result, conntrack program prints "0.0.0.0 ....."
>>
>> A something like filtering with address family might be necessary while
>> dumping. Yes, that would be inefficient. One long term solution would be
>> conntrack hash per layer 3 protocol.
> 
> 
> The filtering sounds fine for now. Dumping already has a large overhead
> because the repeated iterations over the entire hash to find out where
> to continue after an skb was full, this is not going to make it much
> worse. I'm going to fix it up when adding the patch.

What about the patch attached? It applies on top of my previous global
ctnetlink port to nf_conntrack take#4 patch.

-- 
Pablo

--------------000405090107040906000001
Content-Type: text/plain;
 name="family.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="family.patch"

[NETFILTER] Dump entries based on the layer 3 protocol number

Dump entries of a given Layer 3 protocol number.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/netfilter/nf_conntrack_netlink.c	2005-12-15 13:47:10.000000000 +0100
+++ netfilter-2.6.14.git/net/netfilter/nf_conntrack_netlink.c	2005-12-15 20:12:21.000000000 +0100
@@ -400,6 +400,8 @@ static int ctnetlink_done(struct netlink
 	return 0;
 }
 
+#define L3PROTO(ct) ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -407,6 +409,8 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
@@ -418,6 +422,11 @@ ctnetlink_dump_table(struct sk_buff *skb
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			/* Dump entries of a given L3 protocol number.
+			 * If it is not specified, ie. l3proto == 0,
+			 * then dump everything. */
+			if (l3proto && L3PROTO(ct) != l3proto)
+				continue;
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -444,6 +453,8 @@ ctnetlink_dump_table_w(struct sk_buff *s
 	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;	
 
 	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
@@ -455,6 +466,8 @@ ctnetlink_dump_table_w(struct sk_buff *s
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (l3proto && L3PROTO(ct) != l3proto)
+				continue;
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -750,9 +763,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
-		if (nfmsg->nfgen_family != AF_INET)
-			return -EAFNOSUPPORT;
-
 		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
 					IPCTNL_MSG_CT_GET_CTRZERO) {
 #ifdef CONFIG_NF_CT_ACCT
@@ -1251,12 +1261,16 @@ ctnetlink_exp_dump_table(struct sk_buff 
 	struct nf_conntrack_expect *exp = NULL;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[0];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
 
 	read_lock_bh(&nf_conntrack_lock);
 	list_for_each_prev(i, &nf_conntrack_expect_list) {
 		exp = (struct nf_conntrack_expect *) i;
+		if (l3proto && exp->tuple.src.l3num != l3proto)
+			continue;
 		if (exp->id <= *id)
 			continue;
 		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -1298,9 +1312,6 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
-		if (nfmsg->nfgen_family != AF_INET)
-			return -EAFNOSUPPORT;
-
 		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
 		    				ctnetlink_exp_dump_table,
 						ctnetlink_done)) != 0)

--------------000405090107040906000001--
