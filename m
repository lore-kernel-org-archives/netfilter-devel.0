From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 0/3] src: add nft log flags support
Date: Sun, 25 Sep 2016 17:06:58 +0800
Message-ID: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:42808 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbcIYJHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 05:07:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After NF_LOG_XXX is exposed to the userspace, we can set log flags to
log more things. The following iptables rule:
  # iptables -A OUTPUT -j LOG --log-tcp-sequence --log-tcp-options \
  --log-ip-options --log-uid --log-macdecode
is equal to the following nft rule:
  # nft add rule filter OUTPUT log tcpseq,tcpopt,ipopt,uid,macdecode

The syntax supported was done by patch #1, user manual was updated by
patch #2, test case was added by patch #3.

After this patch set is accepted, I will send another patch to do
iptables xlat.

Liping Zhang (3):
  src: add log flags syntax support
  doc: add description about log flags
  tests: py: add some testcases for log flags

 doc/nft.xml                       | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/netfilter/nf_log.h  | 12 ++++++++++++
 include/statement.h               |  1 +
 src/evaluate.c                    | 12 +++++++++---
 src/netlink_delinearize.c         |  4 ++++
 src/netlink_linearize.c           |  3 +++
 src/parser_bison.y                | 26 +++++++++++++++++++++++++-
 src/scanner.l                     |  5 +++++
 src/statement.c                   | 24 ++++++++++++++++++++++++
 tests/py/any/log.t                |  4 ++++
 tests/py/any/log.t.payload        | 33 ++++++++++++++++++++-------------
 tests/py/ip/icmp.t.payload.ip     |  2 +-
 tests/py/ip6/icmpv6.t.payload.ip6 |  6 +++---
 13 files changed, 147 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/netfilter/nf_log.h

-- 
2.5.5


