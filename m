From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:nf_tables-experiments 19/19]
 net/ipv4/netfilter/nft_chain_nat_ipv4.c:48:35: sparse: incorrect type in
 assignment (different base types)
Date: Tue, 06 Nov 2012 01:54:56 +0800
Message-ID: <5097fd70.CRHa9w74Q9Q+irJK%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2KERzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:55:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   git://150.214.188.80/nf-next nf_tables-experiments
head:   4581c95a751df71f77861c95f3b34882c37bb2fe
commit: 4581c95a751df71f77861c95f3b34882c37bb2fe [19/19] netfilter: nf_tables: replace built-in tables by chain types


sparse warnings:

+ net/ipv4/netfilter/nft_chain_nat_ipv4.c:48:35: sparse: incorrect type in assignment (different base types)
net/ipv4/netfilter/nft_chain_nat_ipv4.c:48:35:    expected restricted __be32 [addressable] [usertype] ip
net/ipv4/netfilter/nft_chain_nat_ipv4.c:48:35:    got unsigned int [unsigned] <noident>
net/ipv4/netfilter/nft_chain_nat_ipv4.c:49:35: sparse: incorrect type in assignment (different base types)
net/ipv4/netfilter/nft_chain_nat_ipv4.c:49:35:    expected restricted __be32 [addressable] [usertype] ip
net/ipv4/netfilter/nft_chain_nat_ipv4.c:49:35:    got unsigned int [unsigned] <noident>
net/ipv4/netfilter/nft_chain_nat_ipv4.c:54:37: sparse: incorrect type in assignment (different base types)
net/ipv4/netfilter/nft_chain_nat_ipv4.c:54:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/ipv4/netfilter/nft_chain_nat_ipv4.c:54:37:    got unsigned int [unsigned] <noident>
net/ipv4/netfilter/nft_chain_nat_ipv4.c:55:37: sparse: incorrect type in assignment (different base types)
net/ipv4/netfilter/nft_chain_nat_ipv4.c:55:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/ipv4/netfilter/nft_chain_nat_ipv4.c:55:37:    got unsigned int [unsigned] <noident>

vim +48 net/ipv4/netfilter/nft_chain_nat_ipv4.c

a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  32  	enum nft_registers	sreg_proto_min:8;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  33  	enum nft_registers	sreg_proto_max:8;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  34  	enum nf_nat_manip_type	type;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  35  };
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  36  
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  37  static void nft_nat_eval(const struct nft_expr *expr,
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  38  			 struct nft_data data[NFT_REG_MAX + 1],
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  39  			 const struct nft_pktinfo *pkt)
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  40  {
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  41  	const struct nft_nat *priv = nft_expr_priv(expr);
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  42  	enum ip_conntrack_info ctinfo;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  43  	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  44  	struct nf_nat_range range;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  45  
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  46  	memset(&range, 0, sizeof(range));
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  47  	if (priv->sreg_addr_min) {
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16 @48  		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  49  		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  50  		range.flags |= NF_NAT_RANGE_MAP_IPS;
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  51  	}
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  52  
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  53  	if (priv->sreg_proto_min) {
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  54  		range.min_proto.all = data[priv->sreg_proto_min].data[0];
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  55  		range.max_proto.all = data[priv->sreg_proto_max].data[0];
a6332633 net/ipv4/netfilter/nf_table_nat_ipv4.c Pablo Neira Ayuso 2012-09-16  56  		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
