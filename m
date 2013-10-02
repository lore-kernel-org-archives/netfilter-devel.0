From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 0/4] fix rule flush operation
Date: Thu,  3 Oct 2013 01:08:04 +0200
Message-ID: <1380755288-17587-1-git-send-email-eric@regit.org>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50351 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3JBXIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:08:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small patchset which fixes rule flushing. A command
like:
 nft flush table ip6 nat 
was not flushing the rules at all. Patch 4 fixes the problem
and patch 3 limit the scope of the flush which was not limited.

Patchset statistics:
 src/mnl.c     |  2 +-
 src/netlink.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

BR,
--
Eric Leblond
