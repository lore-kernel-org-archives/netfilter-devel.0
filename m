From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 0/3] netfilter: fix some small bugs related to nft_log
Date: Mon, 18 Jul 2016 20:44:14 +0800
Message-ID: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:54036 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbcGRMpD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 08:45:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patchset is very small, aim to fix some bugs related to nftables log expr.

patch#1 fix a possible memory leak if the user specify the log prefix but the log
expr init fail.

patch#2 add a validity check of log level, otherwise user can specify an invalid
log level.

patch#3 fix "nft add rule filter input log snaplen 100" cannot work successfully,
the reason is similar to xt_NFLOG.

Liping Zhang (3):
  netfilter: nft_log: fix possible memory leak if log expr init fail
  netfilter: nft_log: check the validity of log level
  netfilter: nft_log: fix snaplen does not truncate packets

 net/netfilter/nft_log.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

-- 
2.5.5


