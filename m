From: pablo@netfilter.org
Subject: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Thu, 11 Oct 2012 12:17:35 +0200
Message-ID: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53269 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758335Ab2JKKRs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:17:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

The following patchset contain fixes for stable 3.4 onwards.

The selected three patches are:

283283c ipvs: fix oops in ip_vs_dst_event on rmmod
66b6aaf netfilter: nf_conntrack: fix racy timer handling with reliable events
a73f89a netfilter: ipset: timeout fixing bug broke SET target special timeout value [REQUIRES 127f559 netfilter: ipset: fix timeout value overflow bug]

Please, cherry-pick them. Thanks!
