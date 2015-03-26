From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 0/2] set timeout support
Date: Thu, 26 Mar 2015 13:10:18 +0000
Message-ID: <1427375420-24892-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58478 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbCZNKX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 09:10:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following two patches add support for set timeouts to libnfnl.


Patrick McHardy (2):
  set: add support for set timeouts
  set_elem: add timeout support

 include/libnftnl/set.h              |  8 ++++++
 include/linux/netfilter/nf_tables.h | 10 ++++++++
 include/set.h                       |  2 ++
 include/set_elem.h                  |  2 ++
 src/libnftnl.map                    |  4 +++
 src/set.c                           | 50 +++++++++++++++++++++++++++++++++++++
 src/set_elem.c                      | 38 ++++++++++++++++++++++++++++
 7 files changed, 114 insertions(+)

-- 
2.1.0

