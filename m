From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 0/2] IPv6 improvements
Date: Sun, 29 Sep 2013 11:53:27 +0200
Message-ID: <1380448409-19583-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50853 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3I2Jxq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:53:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset fixes IPv6 prefix computation and adds the
missing part for IPv6 NAT support.

I'm not really happy with the first patch because it seems
the prefixmask is computed during the evaluation. But that
result is not used and the prefix mask is rebuild from the
prefix_len in the netlink phase. 

Eric Leblond (2):
  fix IPv6 prefix computation.
  Add support for IPv6 NAT

 src/evaluate.c            |  8 ++++++--
 src/netlink.c             | 11 +++++++----
 src/netlink_delinearize.c | 16 ++++++++++++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

BR,
-- 
1.8.4.rc3

