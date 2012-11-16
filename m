From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:nf_tables-experiments 24/24]
 net/ipv6/netfilter/nft_chain_nat_ipv6.c:48:2: error: 'IP_MF' undeclared
Date: Fri, 16 Nov 2012 15:17:18 +0800
Message-ID: <50a5e87e.w6qj3WPnr19+yFm4%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52056 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2KPHSB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:18:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   git://150.214.188.80/nf-next nf_tables-experiments
head:   367bd6b3f2ce43a193d91f2e74184cc150dca463
commit: 367bd6b3f2ce43a193d91f2e74184cc150dca463 [24/24] nf_tables: Add support for IPv6 NAT chain
config: make ARCH=x86_64 allmodconfig

All error/warnings:

net/ipv6/netfilter/nft_chain_nat_ipv6.c: In function 'nf_nat_ipv6_fn':
net/ipv6/netfilter/nft_chain_nat_ipv6.c:48:2: error: 'IP_MF' undeclared (first use in this function)
net/ipv6/netfilter/nft_chain_nat_ipv6.c:48:2: note: each undeclared identifier is reported only once for each function it appears in
net/ipv6/netfilter/nft_chain_nat_ipv6.c:48:2: error: 'IP_OFFSET' undeclared (first use in this function)

vim +48 +/IP_MF net/ipv6/netfilter/nft_chain_nat_ipv6.c

367bd6b3 Tomasz Bursztyka 2012-11-15  42  	u8 nexthdr;
367bd6b3 Tomasz Bursztyka 2012-11-15  43  	unsigned int ret;
367bd6b3 Tomasz Bursztyka 2012-11-15  44  
367bd6b3 Tomasz Bursztyka 2012-11-15  45  	if (ct == NULL || nf_ct_is_untracked(ct))
367bd6b3 Tomasz Bursztyka 2012-11-15  46  		return NF_ACCEPT;
367bd6b3 Tomasz Bursztyka 2012-11-15  47  
367bd6b3 Tomasz Bursztyka 2012-11-15 @48  	NF_CT_ASSERT(!(ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)));
367bd6b3 Tomasz Bursztyka 2012-11-15  49  
367bd6b3 Tomasz Bursztyka 2012-11-15  50  	nat = nfct_nat(ct);
367bd6b3 Tomasz Bursztyka 2012-11-15  51  	if (nat == NULL) {

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
