From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 0/2] netfilter: ipvs: some fixes in sctp_conn_schedule
Date: Sun, 20 Aug 2017 13:38:06 +0800
Message-ID: <cover.1503207076.git.lucien.xin@gmail.com>
Cc: pablo@netfilter.org, Alex Gartrell <agartrell@fb.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        horms@verge.net.au, ja@ssi.bg, wensong@linux-vs.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32820 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdHTFiR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2017 01:38:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch 1/2 fixes the regression introduced by commit 5e26b1b3abce.
Patch 2/2 makes ipvs not create conn for sctp ABORT packet.

Xin Long (2):
  netfilter: ipvs: fix the issue that sctp_conn_schedule drops non-INIT
    packet
  netfilter: ipvs: do not create conn for ABORT packet in
    sctp_conn_schedule

 net/netfilter/ipvs/ip_vs_proto_sctp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.1.0

