From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: nf_tables: support per element userdata
Date: Sun,  5 Apr 2015 14:43:37 +0200
Message-ID: <1428237818-31963-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57790 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbDEMnl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 08:43:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for attaching arbitrary userdata to set elements,
such as comments, DNS information etc. The type of information is determined
by userspace.

This is the last patch related to sets for the time being, the next
series will add support for concatenations, before finally adding
stateful expression support to sets.

Please apply, thanks!


Patrick McHardy (1):
  netfilter: nf_tables: support optional userdata for set elements

 include/net/netfilter/nf_tables.h        |  7 +++++++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 34 ++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

-- 
2.1.0

