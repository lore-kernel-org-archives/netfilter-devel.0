From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Wed, 1 Mar 2017 12:41:40 +0100
Message-ID: <20170301114140.GA14753@salvia>
References: <20170226163058.24754-1-alexander@alemayhu.com>
 <20170226202410.GB1827@salvia>
 <20170301112103.GA14422@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: netfilter-devel@vger.kernel.org
To: Alexander Alemayhu <alexander@alemayhu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37866 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752450AbdCALmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 06:42:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C554BA6F1
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:41:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BD16DA807
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:41:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 543EBDA804
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:41:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170301112103.GA14422@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 01, 2017 at 12:21:03PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 26, 2017 at 09:24:10PM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Feb 26, 2017 at 05:30:58PM +0100, Alexander Alemayhu wrote:
> > > Running the test cases in the shell directory while running nft monitor results
> > > in nft exiting with '# ERROR: No such process'. The minimal steps where I could
> > > reproduce is:
> > > 
> > > nft monitor # shell 1
> > > run-tests.sh testcases/sets/0011add_many_elements_0 # shell 2
> > > 
> > > Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
> > > ---
> > > 
> > > Not sure if this is considered a fix or desired behaviour, but I was not
> > > expecting monitor to exit like this.
> > > 
> > >  src/mnl.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/src/mnl.c b/src/mnl.c
> > > index 295dd84a5840..a0066a28b44f 100644
> > > --- a/src/mnl.c
> > > +++ b/src/mnl.c
> > > @@ -1129,7 +1129,10 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
> > >  				printf("# ERROR: We lost some netlink events!\n");
> > >  				continue;
> > >  			}
> > > +
> > >  			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
> > > +			if (errno == ESRCH)
> > > +				continue;
> > 
> > It seems netlink is returning ESRCH when the number of events is high,
> > however, it should hit ENOBUFS instead, this is strange.
> 
> We at least need this fix from kernelspace.
> 
> Basically, the idea is to set socket error to ENOBUFS so the event
> listener knows that we're losing events, this is the correct way to
> report this in terms of netlink semantics.
> 
> Would you give it a try?

Actually, this patch would be better. All return values of these
notify function are ignored, so we can turned it into void.

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ac84686aaafb..2aa8a9d80fbe 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -988,9 +988,9 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 					const struct nlattr *nla, u32 objtype,
 					u8 genmask);
 
-int nft_obj_notify(struct net *net, struct nft_table *table,
-		   struct nft_object *obj, u32 portid, u32 seq,
-		   int event, int family, int report, gfp_t gfp);
+void nft_obj_notify(struct net *net, struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq,
+		    int event, int family, int report, gfp_t gfp);
 
 /**
  *	struct nft_object_type - stateful object type
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff7304ae58ac..dcd59b8518af 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -461,16 +461,15 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -484,12 +483,12 @@ static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_tables(struct sk_buff *skb,
@@ -1050,16 +1049,15 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -1074,12 +1072,12 @@ static int nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_chains(struct sk_buff *skb,
@@ -1934,18 +1932,16 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_rule_notify(const struct nft_ctx *ctx,
-				 const struct nft_rule *rule,
-				 int event)
+static void nf_tables_rule_notify(const struct nft_ctx *ctx,
+				  const struct nft_rule *rule, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -1960,12 +1956,12 @@ static int nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 struct nft_rule_dump_ctx {
@@ -2696,9 +2692,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	return -1;
 }
 
-static int nf_tables_set_notify(const struct nft_ctx *ctx,
-				const struct nft_set *set,
-				int event, gfp_t gfp_flags)
+static void nf_tables_set_notify(const struct nft_ctx *ctx,
+				 const struct nft_set *set, int event,
+			         gfp_t gfp_flags)
 {
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
@@ -2706,9 +2702,8 @@ static int nf_tables_set_notify(const struct nft_ctx *ctx,
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, gfp_flags);
 	if (skb == NULL)
 		goto err;
@@ -2721,10 +2716,12 @@ static int nf_tables_set_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES,
 			     ctx->report, gfp_flags);
-err:
 	if (err < 0)
-		nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+		goto err;
+
+	return;
+err:
+	nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
@@ -3504,10 +3501,10 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	return -1;
 }
 
-static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
-				    const struct nft_set *set,
-				    const struct nft_set_elem *elem,
-				    int event, u16 flags)
+static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
+				     const struct nft_set *set,
+				     const struct nft_set_elem *elem,
+				     int event, u16 flags)
 {
 	struct net *net = ctx->net;
 	u32 portid = ctx->portid;
@@ -3515,9 +3512,8 @@ static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	int err;
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -3531,10 +3527,12 @@ static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, ctx->report,
 			     GFP_KERNEL);
-err:
 	if (err < 0)
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+		goto err;
+
+	return;
+err:
+	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
@@ -4476,18 +4474,17 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	return nft_delobj(&ctx, obj);
 }
 
-int nft_obj_notify(struct net *net, struct nft_table *table,
-		   struct nft_object *obj, u32 portid, u32 seq, int event,
-		   int family, int report, gfp_t gfp)
+void nft_obj_notify(struct net *net, struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq, int event,
+		    int family, int report, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
 	if (skb == NULL)
 		goto err;
@@ -4500,20 +4497,20 @@ int nft_obj_notify(struct net *net, struct nft_table *table,
 	}
 
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
-	}
-	return err;
+	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
-static int nf_tables_obj_notify(const struct nft_ctx *ctx,
-				struct nft_object *obj, int event)
+static void nf_tables_obj_notify(const struct nft_ctx *ctx,
+				 struct nft_object *obj, int event)
 {
-	return nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
-			      ctx->seq, event, ctx->afi->family, ctx->report,
-			      GFP_KERNEL);
+	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
+		       ctx->afi->family, ctx->report, GFP_KERNEL);
 }
 
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
@@ -4543,7 +4540,8 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	return -EMSGSIZE;
 }
 
-static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
+static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
+				 int event)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(skb);
 	struct sk_buff *skb2;
@@ -4551,9 +4549,8 @@ static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
 
 	if (nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb2 = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb2 == NULL)
 		goto err;
@@ -4567,12 +4564,13 @@ static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
 
 	err = nfnetlink_send(skb2, net, NETLINK_CB(skb).portid,
 			     NFNLGRP_NFTABLES, nlmsg_report(nlh), GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
+			  -ENOBUFS);
 }
 
 static int nf_tables_getgen(struct net *net, struct sock *nlsk,

--/04w6evG8XlLl3ft--
