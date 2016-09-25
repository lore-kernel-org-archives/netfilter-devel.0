From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 0/3] expr: complete log flags support
Date: Sun, 25 Sep 2016 16:54:32 +0800
Message-ID: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:41239 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbcIYIz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:55:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After NF_LOG_XXX is exposed to the userspace, it's easy to complete log
flags support in libnftnl. Instead of print hex value of flags, it's
better to print human readable string format. This is done by patch #3.

Also there's some trivial problems to be solved:
  Fix a typo by patch #1
  Print out prefix when necessary by patch #2.

Liping Zhang (3):
  expr: log: fix typo in nftnl_expr_log_export
  expr: log: do not print prefix if it is not set
  expr: log: complete log flags support

 include/linux/netfilter/nf_log.h | 12 +++++++++++
 src/expr/log.c                   | 43 ++++++++++++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/netfilter/nf_log.h

-- 
2.5.5


