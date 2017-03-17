From: fgao@ikuai8.com
Subject: [PATCH nf-next 0/4] Refine the nat helper codes
Date: Fri, 17 Mar 2017 14:45:48 +0800
Message-ID: <cover.1489726438.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg278.qq.com ([113.108.11.203]:60930 "EHLO smtpbg278.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdCQGrK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 02:47:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some netfilter functions which return the literal 1 and 0 as
the bool value. We should use bool instead of them.
And even though some calleris treat the return value as Neftiler action.
For example, the caller would compare the return value with NF_ACCEPT.

Luckily the value of NF_ACCEPT is 1, so there is no any real issue.


Gao Feng (4):
  netfilter: amanda: Correct the return value comparison of the func
    nf_nat_mangle_udp_packet
  netfilter: irc: Correct the return value comparison of the func    
    nf_nat_mangle_tcp_packet
  netfilter: helper: Use the bool instead of int type
  netfilter: sip: Use NF_DROP and NF_ACCEPT instead of 0 and 1

 include/net/netfilter/nf_nat_helper.h | 36 +++++++++++++++----------------
 net/netfilter/nf_nat_amanda.c         | 11 +++++-----
 net/netfilter/nf_nat_helper.c         | 40 +++++++++++++++++------------------
 net/netfilter/nf_nat_irc.c            |  9 ++++----
 net/netfilter/nf_nat_sip.c            |  6 +++---
 5 files changed, 50 insertions(+), 52 deletions(-)

-- 
1.9.1


