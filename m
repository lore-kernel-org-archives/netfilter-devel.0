From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [HEADS UP] rebase nf-next
Date: Tue, 9 Sep 2014 16:41:05 +0200
Message-ID: <20140909144105.GA31244@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59847 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbaIIOkS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:40:18 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

kbuild reported this:

Note: the nftables/master HEAD
cd07f7cc59a0e7f8bba30166acf2c13c6b0ae2e3 builds fine.
      It only hurts bisectibility.

All error/warnings:

>> net/ipv6/netfilter/nft_chain_nat_ipv6.c:31:21: error: conflicting
>> types for 'nf_nat_ipv6_fn'
    static unsigned int nf_nat_ipv6_fn(const struct nf_hook_ops *ops,
                        ^
   In file included from net/ipv6/netfilter/nft_chain_nat_ipv6.c:24:0:
   include/net/netfilter/nf_nat_l3proto.h:115:14: note: previous declaration of 'nf_nat_ipv6_fn' was here
    unsigned int nf_nat_ipv6_fn(const struct nf_hook_ops *ops, struct sk_buff *skb,

When generalizing the NAT IPv6 core, I unfortunately clashed with the
existing nf_nat_ipv6_fn in net/ipv6/netfilter/nft_chain_nat_ipv6.c.

I don't want to pass up this problem in the next pull request, so I'm
fixing it here by renaming nf_nat_ipv6_fn to nft_nat_ipv6_fn in
("netfilter: nat: move specific NAT IPv6 to core") and forcing a push.

Sorry for the inconvenience to those that have a working copy of
nf-next. Thanks.
