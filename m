From: pablo@netfilter.org
Subject: [PATCH] Netfilter/IPVS updates for stable 3.0 onwards
Date: Thu, 11 Oct 2012 12:15:33 +0200
Message-ID: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52379 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323Ab2JKKPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:15:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

The following patchset aims to reduce the Netfilter debt with stable 3.0 and
onwards.

The selected six patches are:

07153c6 netfilter: nf_ct_ipv4: packets with wrong ihl are invalid
3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
f22eb25 netfilter: nf_nat_sip: fix via header translation with multiple parameters
2614f86 netfilter: nf_ct_expect: fix possible access to uninitialized timer
9e33ce4 ipvs: fix oops on NAT reply in br_nf context
82e6bfe netfilter: xt_limit: have r->cost != 0 case work [REQUIRES 7a909ac netfilter: limit, hashlimit: avoid duplicated inline]

I have read stable_rules.txt and I consider they match the requirements.

Please, cherry-pick them. Thanks!
