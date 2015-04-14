From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 0/5] concatenation and dynamic expression instantiation
Date: Tue, 14 Apr 2015 08:00:32 +0100
Message-ID: <1428994837-22120-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44033 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbDNHAl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 03:00:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches add support for the concatenation and dynamic expression
instantiation features to libnftnl.


Patrick McHardy (5):
  headers: resync headers for new register definitions
  data: increase maximum possible data size
  expr: seperate expression parsing and building functions
  set_elem: support expressions attached to set elements
  dynset: support expression templates

 include/data_reg.h                  |  3 +-
 include/expr.h                      |  6 ++++
 include/libnftnl/expr.h             |  5 +---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h | 41 +++++++++++++++++++++++++-
 include/set_elem.h                  |  1 +
 src/expr.c                          | 56 ++++++++++++++++++++++++++++++++----
 src/expr/data_reg.c                 |  2 +-
 src/expr/dynset.c                   | 38 +++++++++++++++++++++++++
 src/libnftnl.map                    |  1 -
 src/rule.c                          | 57 ++++++-------------------------------
 src/set_elem.c                      | 20 +++++++++++++
 12 files changed, 169 insertions(+), 62 deletions(-)

-- 
2.1.0

