From: Patrick McHardy <kaber@trash.net>
Subject: nftables add vs replace
Date: Tue, 21 Jan 2014 11:06:46 +0000
Message-ID: <20140121110645.GC25197@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38277 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaAULGt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:06:49 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently only support "add table" and "add chain" with NLM_F_EXCL.
This means we can't replace entire tables without a lot of extra effort,
also its not possible to create tables/chains just in case they don't
already exist.

To fix this, I'd propose to add two new commands, so we have the following:

- add: add without NLM_F_EXCL
- create: add with NLM_F_EXCL
- replace: replace the entire thing

This most likely will also require updates to the transaction handling
so we don't only process rules, but table, chain and set updates in a
transaction.

Comments?
