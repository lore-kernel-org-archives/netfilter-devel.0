Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1F8C54EBD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 11:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjABLqk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 06:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjABLq0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 06:46:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D242CF7B
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 03:46:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pCJGn-0004qz-F1; Mon, 02 Jan 2023 12:46:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack: cleanups
Date:   Mon,  2 Jan 2023 12:46:09 +0100
Message-Id: <20230102114612.15860-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Get rid of old pr_debug calls.  In some cases, switch
  to nf_log infra, in other cases they can just be removed.

- Some ct->status bits can only be set before the conntrack
  is inserted, such as IPS_NAT_CLASH.  We can avoid refetch
  of ct->status in some cases because of this.

Florian Westphal (3):
  netfilter: conntrack: sctp: use nf log infrastructure for invalid
    packets
  netfilter: conntrack: remove pr_debug calls
  netfilter: conntrack: avoid reload of ct->status

 net/netfilter/nf_conntrack_core.c       | 29 ++++------------
 net/netfilter/nf_conntrack_proto.c      | 20 ++---------
 net/netfilter/nf_conntrack_proto_sctp.c | 46 ++++++++-----------------
 net/netfilter/nf_conntrack_proto_tcp.c  |  9 -----
 net/netfilter/nf_conntrack_proto_udp.c  | 10 +++---
 5 files changed, 31 insertions(+), 83 deletions(-)

-- 
2.38.2

