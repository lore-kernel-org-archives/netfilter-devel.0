From: pablo@netfilter.org
Subject: [PATCH] Netfilter updates for stable 3.5
Date: Thu, 11 Oct 2012 12:09:53 +0200
Message-ID: <1349950194-12422-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758332Ab2JKKKF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:10:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

The following patchset contain fixes for stable 3.5.

The selected patch is:

2dba62c netfilter: nfnetlink_log: fix NLA_PUT macro removal bug

Please, cherry-pick it. Thanks!
