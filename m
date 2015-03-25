From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V2 0/4] add mark target for arptables
Date: Tue, 24 Mar 2015 21:57:32 -0400
Message-ID: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22186 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbbCYCLj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 22:11:39 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2P2Aacn005045
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 10:10:36 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

v1:
  add mark target for arptables

v2:
  add --and-mark
  add --or-mark
  add revision for common api

Zhang Chunyu (4):
  Add MARK target for arptables
  Update the manpage for MARK target
  Add --and-mark and --or-mark
  Add revision field for xt_entry_target

 arptables.8                              |  17 ++++
 arptables.c                              |   2 +
 extensions/Makefile                      |   2 +-
 extensions/arpt_CLASSIFY.c               |   1 +
 extensions/arpt_MARK.c                   | 156 +++++++++++++++++++++++++++++++
 extensions/arpt_mangle.c                 |   1 +
 extensions/arpt_standard.c               |   1 +
 include/arptables.h                      |   6 ++
 include/linux/netfilter_arp/arp_tables.h |   3 +-
 9 files changed, 187 insertions(+), 2 deletions(-)
 create mode 100644 extensions/arpt_MARK.c

-- 
1.7.12.4

