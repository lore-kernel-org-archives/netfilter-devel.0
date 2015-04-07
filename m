From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH] Add NFPROTO_ARP for mark target
Date: Mon, 6 Apr 2015 22:45:15 -0400
Message-ID: <1428374716-15108-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48362 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752884AbbDGC73 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 22:59:29 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t372wK7C029429
	for <netfilter-devel@vger.kernel.org>; Tue, 7 Apr 2015 10:58:20 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this patch is for arptables --set-mark 
http://www.spinics.net/lists/netfilter-devel/msg35913.html

Zhang Chunyu (1):
  Add NFPROTO_ARP for mark

 net/netfilter/xt_mark.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

-- 
1.7.12.4

