From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] libnftnl: dynset dynamic expression instantiation
Date: Sun, 12 Apr 2015 20:35:07 +0100
Message-ID: <1428867310-18327-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61764 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbbDLTfR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:35:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches add support for the dynset dynamic expression instantiation
patches I sent on Friday. I'll push them once those patches have been
merged.


Patrick McHardy (3):
  expr: seperate expression parsing and building functions
  set_elem: support expressions attached to set elements
  dynset: support expression templates

 include/expr.h                      |  6 ++++
 include/libnftnl/expr.h             |  5 +---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set_elem.h                  |  1 +
 src/expr.c                          | 56 ++++++++++++++++++++++++++++++++----
 src/expr/dynset.c                   | 38 +++++++++++++++++++++++++
 src/libnftnl.map                    |  1 -
 src/rule.c                          | 57 ++++++-------------------------------
 src/set_elem.c                      | 20 +++++++++++++
 10 files changed, 128 insertions(+), 59 deletions(-)

-- 
2.1.0

