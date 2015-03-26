From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V3 0/2] add mark target
Date: Thu, 26 Mar 2015 05:33:28 -0400
Message-ID: <1427362410-9255-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25311 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbbCZKBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 06:01:05 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2Q9kK3S020891
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2015 17:46:41 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

v1:
  add mark target for arptables

v2:
  add --and-mark
  add --or-mark
  add revision for common api

v3:
  fold 2/4, 3/4 and 4/4 patch into one single patch
  use C99 initialization
  change some format

Zhang Chunyu (2):
  Add MARK target for arptables

 arptables.8                              |  17 ++++
 arptables.c                              |   2 +
 extensions/Makefile                      |   2 +-
 extensions/arpt_CLASSIFY.c               |   1 +
 extensions/arpt_MARK.c                   | 151 +++++++++++++++++++++++++++++++
 extensions/arpt_mangle.c                 |   1 +
 extensions/arpt_standard.c               |   1 +
 include/arptables.h                      |   6 ++
 include/linux/netfilter_arp/arp_tables.h |   3 +-
 9 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 extensions/arpt_MARK.c

-- 
1.7.12.4

