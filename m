From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:nf_tables-experiments 20/24]
 net/netfilter/nf_tables_api.c:344:23: sparse: incorrect type in assignment
 (different base types)
Date: Tue, 11 Dec 2012 10:42:33 +0800
Message-ID: <50c69d99.ea0DEF4foooCl3Zu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2LKCnR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:43:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   git://150.214.188.80/nf-next nf_tables-experiments
head:   367bd6b3f2ce43a193d91f2e74184cc150dca463
commit: 2d78976507ff7ab747befe7201162a234a3d441c [20/24] netfilter: nf_tables: add support for dormant tables


sparse warnings:

+ net/netfilter/nf_tables_api.c:344:23: sparse: incorrect type in assignment (different base types)
net/netfilter/nf_tables_api.c:344:23:    expected restricted __be32 [usertype] flags
net/netfilter/nf_tables_api.c:344:23:    got unsigned int
+ net/netfilter/nf_tables_api.c:345:21: sparse: restricted __be32 degrades to integer
net/netfilter/nf_tables_api.c:348:22: sparse: restricted __be32 degrades to integer
net/netfilter/nf_tables_api.c:353:30: sparse: restricted __be32 degrades to integer
net/netfilter/nf_tables_api.c:409:23: sparse: incorrect type in assignment (different base types)
net/netfilter/nf_tables_api.c:409:23:    expected restricted __be32 [usertype] flags
net/netfilter/nf_tables_api.c:409:23:    got unsigned int
net/netfilter/nf_tables_api.c:410:21: sparse: restricted __be32 degrades to integer
+ net/netfilter/nf_tables_api.c:413:30: sparse: invalid assignment: |=
net/netfilter/nf_tables_api.c:413:30:    left side has type unsigned short
net/netfilter/nf_tables_api.c:413:30:    right side has type restricted __be32

vim +344 net/netfilter/nf_tables_api.c

2d789765 Pablo Neira Ayuso 2012-11-08  338  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
2d789765 Pablo Neira Ayuso 2012-11-08  339  	int family = nfmsg->nfgen_family, ret = 0;
2d789765 Pablo Neira Ayuso 2012-11-08  340  
2d789765 Pablo Neira Ayuso 2012-11-08  341  	if (nla[NFTA_TABLE_FLAGS]) {
2d789765 Pablo Neira Ayuso 2012-11-08  342  		__be32 flags;
2d789765 Pablo Neira Ayuso 2012-11-08  343  
2d789765 Pablo Neira Ayuso 2012-11-08 @344  		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
2d789765 Pablo Neira Ayuso 2012-11-08 @345  		if (flags & ~NFT_TABLE_F_DORMANT)
2d789765 Pablo Neira Ayuso 2012-11-08  346  			return -EINVAL;
2d789765 Pablo Neira Ayuso 2012-11-08  347  
2d789765 Pablo Neira Ayuso 2012-11-08  348  		if ((flags & NFT_TABLE_F_DORMANT) &&
2d789765 Pablo Neira Ayuso 2012-11-08  349  		    !(table->flags & NFT_TABLE_F_DORMANT)) {
2d789765 Pablo Neira Ayuso 2012-11-08  350  			ret = nf_tables_table_disable(table);
2d789765 Pablo Neira Ayuso 2012-11-08  351  			if (ret >= 0)
2d789765 Pablo Neira Ayuso 2012-11-08  352  				table->flags |= NFT_TABLE_F_DORMANT;
2d789765 Pablo Neira Ayuso 2012-11-08  353  		} else if (!(flags & NFT_TABLE_F_DORMANT) &&
2d789765 Pablo Neira Ayuso 2012-11-08  354  			   table->flags & NFT_TABLE_F_DORMANT) {
2d789765 Pablo Neira Ayuso 2012-11-08  355  			ret = nf_tables_table_enable(table);
2d789765 Pablo Neira Ayuso 2012-11-08  356  			if (ret >= 0)
2d789765 Pablo Neira Ayuso 2012-11-08  357  				table->flags &= ~NFT_TABLE_F_DORMANT;
2d789765 Pablo Neira Ayuso 2012-11-08  358  		}
2d789765 Pablo Neira Ayuso 2012-11-08  359  		if (ret < 0)
2d789765 Pablo Neira Ayuso 2012-11-08  360  			goto err;
2d789765 Pablo Neira Ayuso 2012-11-08  361  	}
2d789765 Pablo Neira Ayuso 2012-11-08  362  
2d789765 Pablo Neira Ayuso 2012-11-08  363  	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
2d789765 Pablo Neira Ayuso 2012-11-08  364  err:
2d789765 Pablo Neira Ayuso 2012-11-08  365  	return ret;
2d789765 Pablo Neira Ayuso 2012-11-08  366  }
2d789765 Pablo Neira Ayuso 2012-11-08  367  
a6332633 Pablo Neira Ayuso 2012-09-16  368  static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
a6332633 Pablo Neira Ayuso 2012-09-16  369  			      const struct nlmsghdr *nlh,
a6332633 Pablo Neira Ayuso 2012-09-16  370  			      const struct nlattr * const nla[])
a6332633 Pablo Neira Ayuso 2012-09-16  371  {
a6332633 Pablo Neira Ayuso 2012-09-16  372  	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
a6332633 Pablo Neira Ayuso 2012-09-16  373  	const struct nlattr *name;
a6332633 Pablo Neira Ayuso 2012-09-16  374  	struct nft_af_info *afi;
a6332633 Pablo Neira Ayuso 2012-09-16  375  	struct nft_table *table;
a6332633 Pablo Neira Ayuso 2012-09-16  376  	int family = nfmsg->nfgen_family;
a6332633 Pablo Neira Ayuso 2012-09-16  377  
a6332633 Pablo Neira Ayuso 2012-09-16  378  	afi = nf_tables_afinfo_lookup(family, true);
a6332633 Pablo Neira Ayuso 2012-09-16  379  	if (IS_ERR(afi))
a6332633 Pablo Neira Ayuso 2012-09-16  380  		return PTR_ERR(afi);
a6332633 Pablo Neira Ayuso 2012-09-16  381  
a6332633 Pablo Neira Ayuso 2012-09-16  382  	name = nla[NFTA_TABLE_NAME];
4581c95a Pablo Neira Ayuso 2012-11-05  383  	table = nf_tables_table_lookup(afi, name);
a6332633 Pablo Neira Ayuso 2012-09-16  384  	if (IS_ERR(table)) {
a6332633 Pablo Neira Ayuso 2012-09-16  385  		if (PTR_ERR(table) != -ENOENT)
a6332633 Pablo Neira Ayuso 2012-09-16  386  			return PTR_ERR(table);
a6332633 Pablo Neira Ayuso 2012-09-16  387  		table = NULL;
a6332633 Pablo Neira Ayuso 2012-09-16  388  	}
a6332633 Pablo Neira Ayuso 2012-09-16  389  
a6332633 Pablo Neira Ayuso 2012-09-16  390  	if (table != NULL) {
a6332633 Pablo Neira Ayuso 2012-09-16  391  		if (nlh->nlmsg_flags & NLM_F_EXCL)
a6332633 Pablo Neira Ayuso 2012-09-16  392  			return -EEXIST;
a6332633 Pablo Neira Ayuso 2012-09-16  393  		if (nlh->nlmsg_flags & NLM_F_REPLACE)
a6332633 Pablo Neira Ayuso 2012-09-16  394  			return -EOPNOTSUPP;
2d789765 Pablo Neira Ayuso 2012-11-08  395  		return nf_tables_updtable(nlsk, skb, nlh, nla, afi, table);
a6332633 Pablo Neira Ayuso 2012-09-16  396  	}
a6332633 Pablo Neira Ayuso 2012-09-16  397  
a6332633 Pablo Neira Ayuso 2012-09-16  398  	table = kzalloc(sizeof(*table) + nla_len(name), GFP_KERNEL);
a6332633 Pablo Neira Ayuso 2012-09-16  399  	if (table == NULL)
a6332633 Pablo Neira Ayuso 2012-09-16  400  		return -ENOMEM;
a6332633 Pablo Neira Ayuso 2012-09-16  401  
a6332633 Pablo Neira Ayuso 2012-09-16  402  	nla_strlcpy(table->name, name, nla_len(name));
a6332633 Pablo Neira Ayuso 2012-09-16  403  	INIT_LIST_HEAD(&table->chains);
a6332633 Pablo Neira Ayuso 2012-09-16  404  	INIT_LIST_HEAD(&table->sets);
a6332633 Pablo Neira Ayuso 2012-09-16  405  
2d789765 Pablo Neira Ayuso 2012-11-08  406  	if (nla[NFTA_TABLE_FLAGS]) {
2d789765 Pablo Neira Ayuso 2012-11-08  407  		__be32 flags;
2d789765 Pablo Neira Ayuso 2012-11-08  408  
2d789765 Pablo Neira Ayuso 2012-11-08  409  		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
2d789765 Pablo Neira Ayuso 2012-11-08 @410  		if (flags & ~NFT_TABLE_F_DORMANT)
2d789765 Pablo Neira Ayuso 2012-11-08  411  			return -EINVAL;
2d789765 Pablo Neira Ayuso 2012-11-08  412  
2d789765 Pablo Neira Ayuso 2012-11-08 @413  		table->flags |= flags;
2d789765 Pablo Neira Ayuso 2012-11-08  414  	}
2d789765 Pablo Neira Ayuso 2012-11-08  415  
a6332633 Pablo Neira Ayuso 2012-09-16  416  	list_add_tail(&table->list, &afi->tables);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
