From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 0/3] Generalize nft_rule_list() (+ 2 fixes)
Date: Wed,  7 Aug 2013 11:31:34 +0300
Message-ID: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab3HGIbu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:31:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Proper refactorization of nft_rule_list() so it uses nft_family_ops .print_firewall, thus enabling its usage by other family such as ARP etc...

2 small fixes: one about optimization (patch 1), and one about the output (patch 3)

Tomasz Bursztyka (3):
  nft: Remove useless test on rulenum in nft_rule_list()
  nft: Generalize nft_rule_list() against current family
  nft: Print unknown target data only when relevant

 iptables/nft-ipv4.c   |  39 ++++++--
 iptables/nft-ipv6.c   |  39 ++++++--
 iptables/nft-shared.c | 239 +++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |  13 ++-
 iptables/nft.c        | 254 ++------------------------------------------------
 5 files changed, 317 insertions(+), 267 deletions(-)

-- 
1.8.3.2

