From: Eric Leblond <eric@regit.org>
Subject: [PATCHv3 nftables insert operation]
Date: Sat,  6 Jul 2013 17:31:16 +0200
Message-ID: <1373124677-6626-1-git-send-email-eric@regit.org>
References: <20130629102418.GA5518@localhost>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59737 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3GFPbv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:31:51 -0400
In-Reply-To: <20130629102418.GA5518@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Here's a rework of previous patch. Kernel patch, libnftables
and nftables patches are to follow.

libnftables patchset statistics:
 examples/Makefile.am                |   4 +
 examples/nft-rule-insert.c          | 204 ++++++++++++++++++++++++++++++++++++
 include/libnftables/rule.h          |   3 +-
 include/linux/netfilter/nf_tables.h |   1 +
 src/rule.c                          |  29 ++++-
 5 files changed, 237 insertions(+), 4 deletions(-)

nftables patchset statistics:
 include/rule.h            |  2 ++
 src/netlink.c             |  2 ++
 src/netlink_delinearize.c |  2 ++
 src/parser.y              | 22 ++++++++++++++++++++--
 src/rule.c                |  2 ++
 src/scanner.l             |  3 +++
 6 files changed, 31 insertions(+), 2 deletions(-)

BR,
--
Eric
