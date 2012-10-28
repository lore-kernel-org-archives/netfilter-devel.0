From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [nf-next:nf_tables7 3/3] net/netfilter/nf_tables_api.c:1299:1:
 warning: the frame size of 1184 bytes is larger than 1024 bytes
Date: Sun, 28 Oct 2012 14:07:36 +0800
Message-ID: <20121028060736.GA32717@localhost>
References: <508cc50d.M5tgqmAbgcg453NH%yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2J1GHj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 02:07:39 -0400
Content-Disposition: inline
In-Reply-To: <508cc50d.M5tgqmAbgcg453NH%yuanhan.liu@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

FYI, there are new compile warnings show up in

tree:   git://150.214.188.80/nf-next nf_tables7
head:   a6332633391e97de473423052cb6173b4e6e7a27
commit: a6332633391e97de473423052cb6173b4e6e7a27 [3/3] netfilter: nf_tables
config: m68k-allmodconfig # make ARCH=m68k allmodconfig

All warnings:

net/netfilter/nf_tables_api.c: In function 'nf_tables_newrule':
net/netfilter/nf_tables_api.c:1299:1: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]
--
net/netfilter/nft_ct.c: In function 'nft_ct_eval':
net/netfilter/nft_ct.c:77:46: warning: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Wparentheses]

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
