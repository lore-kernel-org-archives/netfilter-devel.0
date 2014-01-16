From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/2]: nftables: segtree fixes
Date: Thu, 16 Jan 2014 16:21:50 +0000
Message-ID: <1389889312-4055-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57338 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaAPQWD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:22:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix a couple of broken cases and improve readability
in interval decomposition.

- mark datatypes where representations as prefixes is preferrable to ranges,
  like IP addresses, and use that to decide whether to use prefix or range
  expressions if both are possible

- fix a couple of bugs wrt. unclosed intervals

I'm working on some further improvements and cleanups, but these are the
minimum we should put in for the upcoming release to make the output
both understandable and correct.

Signed-off-by: Patrick McHardy <kaber@trash.net>
