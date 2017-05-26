From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 7/9] netfilter: nf_tables: allow large
 allocations for new sets
Date: Fri, 26 May 2017 12:18:29 +0200
Message-ID: <20170526101829.GA2274@salvia>
References: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
 <1495619453-22307-8-git-send-email-pablo@netfilter.org>
 <CAML_gOcajZUmbsFb56BFwAFe-hje-jT3nvF3A99JOg9khTMMdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030453AbdEZKSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 06:18:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 933A619F420
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 12:18:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 833ED10078E
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 12:18:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73CAB100796
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 12:18:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOcajZUmbsFb56BFwAFe-hje-jT3nvF3A99JOg9khTMMdA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 26, 2017 at 06:02:34PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-05-24 17:50 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> > -       err = -ENOMEM;
> > -       set = kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
> > +       alloc_size = sizeof(*set) + size + udlen;
> > +       if (alloc_size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
> > +               set = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN |
> > +                                         __GFP_NORETRY);
> >         if (set == NULL)
> > +               set = vzalloc(alloc_size);
> 
> I think maybe we can use "set = kvzalloc(alloc_size, GFP_KERNEL);" to simplify
> the above codes.

Like this?

--0OAP2g/MAC+5xKAE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e54090caa8a..bd4fc8b2cd77 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2910,7 +2910,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
-	unsigned int size, alloc_size;
 	const struct nft_set_ops *ops;
 	struct nft_af_info *afi;
 	struct nft_table *table;
@@ -2922,6 +2921,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct nft_set_desc desc;
 	unsigned char *udata;
+	unsigned int size;
 	u16 udlen;
 	int err;
 
@@ -3057,13 +3057,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 
-	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
-		set = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN |
-					  __GFP_NORETRY);
-	if (set == NULL)
-		set = vzalloc(alloc_size);
-	if (set == NULL) {
+	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
+	if (!set) {
 		err = -ENOMEM;
 		goto err1;
 	}

--0OAP2g/MAC+5xKAE--
