From: pablo@netfilter.org
Subject: [PATCH 0/3] [-stable] Netfilter updates for stable 3.6
Date: Fri, 16 Nov 2012 15:02:27 +0100
Message-ID: <1353074550-21456-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36626 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2KPOCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:02:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

Please, consider the following Netfilter patches for stable 3.6 and
onwards inclusion.

The selected three patches are:

2ad5b9e netfilter: xt_TEE: don't use destination address found in header
bbb5823 netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper
0153d5a netfilter: xt_CT: fix timeout setting with IPv6 [REQUIRES: 236df00 netfilter: xt_CT: refactorize xt_ct_tg_check]

More relevantly, the first patch fix the TEE target, which is broken in 3.6.

Please, cherry-pick them. Thanks!

Eric Dumazet (1):
  netfilter: xt_TEE: don't use destination address found in header

Julian Anastasov (1):
  netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper

Pablo Neira Ayuso (1):
  netfilter: xt_CT: fix timeout setting with IPv6

--
1.7.10.4

