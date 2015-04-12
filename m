From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] libnfnl: support for new set features
Date: Sun, 12 Apr 2015 20:24:46 +0100
Message-ID: <1428866689-17679-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbbDLTYy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:24:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches add the remaining support for the new set features in
net-next, namely

- comments attached to set elements
- the dynset expression

Additionally the set timeout debugging information is slightly enhanded.


Patrick McHardy (3):
  set: print set elem timeout information
  set_elem: add support for userdata
  expr: add support for the dynset expr

 include/buffer.h                    |   3 +
 include/libnftnl/expr.h             |   9 +
 include/libnftnl/set.h              |   1 +
 include/linux/netfilter/nf_tables.h |  29 ++++
 include/set_elem.h                  |   4 +
 src/Makefile.am                     |   1 +
 src/expr/dynset.c                   | 317 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 src/set.c                           |  13 ++
 src/set_elem.c                      |  47 ++++++
 10 files changed, 426 insertions(+)
 create mode 100644 src/expr/dynset.c

-- 
2.1.0

