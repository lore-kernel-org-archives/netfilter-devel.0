From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Wed, 1 Mar 2017 12:21:03 +0100
Message-ID: <20170301112103.GA14422@salvia>
References: <20170226163058.24754-1-alexander@alemayhu.com>
 <20170226202410.GB1827@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Cc: netfilter-devel@vger.kernel.org
To: Alexander Alemayhu <alexander@alemayhu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752583AbdCALol (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 06:44:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BB761A208F
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:21:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0952DDA818
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:21:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39A43DA7F7
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 12:21:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170226202410.GB1827@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 26, 2017 at 09:24:10PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 26, 2017 at 05:30:58PM +0100, Alexander Alemayhu wrote:
> > Running the test cases in the shell directory while running nft monitor results
> > in nft exiting with '# ERROR: No such process'. The minimal steps where I could
> > reproduce is:
> > 
> > nft monitor # shell 1
> > run-tests.sh testcases/sets/0011add_many_elements_0 # shell 2
> > 
> > Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
> > ---
> > 
> > Not sure if this is considered a fix or desired behaviour, but I was not
> > expecting monitor to exit like this.
> > 
> >  src/mnl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 295dd84a5840..a0066a28b44f 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -1129,7 +1129,10 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
> >  				printf("# ERROR: We lost some netlink events!\n");
> >  				continue;
> >  			}
> > +
> >  			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
> > +			if (errno == ESRCH)
> > +				continue;
> 
> It seems netlink is returning ESRCH when the number of events is high,
> however, it should hit ENOBUFS instead, this is strange.

We at least need this fix from kernelspace.

Basically, the idea is to set socket error to ENOBUFS so the event
listener knows that we're losing events, this is the correct way to
report this in terms of netlink semantics.

Would you give it a try?

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff7304ae58ac..76b79bd0f25a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -486,10 +486,11 @@ static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 			     ctx->report, GFP_KERNEL);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
+		if (nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
 	}
-	return err;
+	return 0;
 }
 
 static int nf_tables_dump_tables(struct sk_buff *skb,
@@ -1076,10 +1077,11 @@ static int nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 			     ctx->report, GFP_KERNEL);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
+		if (nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
 	}
-	return err;
+	return 0;
 }
 
 static int nf_tables_dump_chains(struct sk_buff *skb,
@@ -1962,10 +1964,11 @@ static int nf_tables_rule_notify(const struct nft_ctx *ctx,
 			     ctx->report, GFP_KERNEL);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
+		if (nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
 	}
-	return err;
+	return 0;
 }
 
 struct nft_rule_dump_ctx {
@@ -2722,9 +2725,12 @@ static int nf_tables_set_notify(const struct nft_ctx *ctx,
 	err = nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES,
 			     ctx->report, gfp_flags);
 err:
-	if (err < 0)
-		nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+	if (err < 0) {
+		if (nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
+	}
+	return 0;
 }
 
 static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
@@ -3532,9 +3538,12 @@ static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, ctx->report,
 			     GFP_KERNEL);
 err:
-	if (err < 0)
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+	if (err < 0) {
+		if (nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
+	}
+	return 0;
 }
 
 static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
@@ -4502,9 +4511,11 @@ int nft_obj_notify(struct net *net, struct nft_table *table,
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
+		if (nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES,
+				      -ENOBUFS) > 0)
+			return -ENOBUFS;
 	}
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
@@ -4569,10 +4580,11 @@ static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
 			     NFNLGRP_NFTABLES, nlmsg_report(nlh), GFP_KERNEL);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
-				  err);
+		if (nfnetlink_set_err(net, NETLINK_CB(skb).portid,
+				      NFNLGRP_NFTABLES, -ENOBUFS) > 0)
+			return -ENOBUFS;
 	}
-	return err;
+	return 0;
 }
 
 static int nf_tables_getgen(struct net *net, struct sock *nlsk,

--Nq2Wo0NMKNjxTN9z--
