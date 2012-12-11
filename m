From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:nf_tables-experiments 22/24]
 net/netfilter/nft_nat.c:47:35: sparse: incorrect type in assignment
 (different base types)
Date: Tue, 11 Dec 2012 10:45:11 +0800
Message-ID: <50c69e37.iVGFEm5+XMFz4aHx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2LKCpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:45:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   git://150.214.188.80/nf-next nf_tables-experiments
head:   367bd6b3f2ce43a193d91f2e74184cc150dca463
commit: 6351b5f82df6d860ba179697d574cadc7fa2e515 [22/24] nf_tables: Split IPv4 NAT into NAT expression and IPv4 NAT chain


sparse warnings:

+ net/netfilter/nft_nat.c:47:35: sparse: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:47:35:    expected restricted __be32 [addressable] [usertype] ip
net/netfilter/nft_nat.c:47:35:    got unsigned int [unsigned] <noident>
net/netfilter/nft_nat.c:48:35: sparse: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:48:35:    expected restricted __be32 [addressable] [usertype] ip
net/netfilter/nft_nat.c:48:35:    got unsigned int [unsigned] <noident>
net/netfilter/nft_nat.c:53:37: sparse: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:53:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/netfilter/nft_nat.c:53:37:    got unsigned int [unsigned] <noident>
net/netfilter/nft_nat.c:54:37: sparse: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:54:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/netfilter/nft_nat.c:54:37:    got unsigned int [unsigned] <noident>

vim +47 net/netfilter/nft_nat.c

6351b5f8 Tomasz Bursztyka 2012-11-15  31  	enum nft_registers      sreg_proto_min:8;
6351b5f8 Tomasz Bursztyka 2012-11-15  32  	enum nft_registers      sreg_proto_max:8;
6351b5f8 Tomasz Bursztyka 2012-11-15  33  	enum nf_nat_manip_type  type;
6351b5f8 Tomasz Bursztyka 2012-11-15  34  };
6351b5f8 Tomasz Bursztyka 2012-11-15  35  
6351b5f8 Tomasz Bursztyka 2012-11-15  36  static void nft_nat_eval(const struct nft_expr *expr,
6351b5f8 Tomasz Bursztyka 2012-11-15  37  			 struct nft_data data[NFT_REG_MAX + 1],
6351b5f8 Tomasz Bursztyka 2012-11-15  38  			 const struct nft_pktinfo *pkt)
6351b5f8 Tomasz Bursztyka 2012-11-15  39  {
6351b5f8 Tomasz Bursztyka 2012-11-15  40  	const struct nft_nat *priv = nft_expr_priv(expr);
6351b5f8 Tomasz Bursztyka 2012-11-15  41  	enum ip_conntrack_info ctinfo;
6351b5f8 Tomasz Bursztyka 2012-11-15  42  	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
6351b5f8 Tomasz Bursztyka 2012-11-15  43  	struct nf_nat_range range;
6351b5f8 Tomasz Bursztyka 2012-11-15  44  
6351b5f8 Tomasz Bursztyka 2012-11-15  45  	memset(&range, 0, sizeof(range));
6351b5f8 Tomasz Bursztyka 2012-11-15  46  	if (priv->sreg_addr_min) {
6351b5f8 Tomasz Bursztyka 2012-11-15 @47  		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
6351b5f8 Tomasz Bursztyka 2012-11-15  48  		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
6351b5f8 Tomasz Bursztyka 2012-11-15  49  		range.flags |= NF_NAT_RANGE_MAP_IPS;
6351b5f8 Tomasz Bursztyka 2012-11-15  50  	}
6351b5f8 Tomasz Bursztyka 2012-11-15  51  
6351b5f8 Tomasz Bursztyka 2012-11-15  52  	if (priv->sreg_proto_min) {
6351b5f8 Tomasz Bursztyka 2012-11-15  53  		range.min_proto.all = data[priv->sreg_proto_min].data[0];
6351b5f8 Tomasz Bursztyka 2012-11-15  54  		range.max_proto.all = data[priv->sreg_proto_max].data[0];
6351b5f8 Tomasz Bursztyka 2012-11-15  55  		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
