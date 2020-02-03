Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B6AC35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A992082E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgBCQhR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:37:17 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59376 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731059AbgBCQhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:15 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iyein-0005Xs-BW; Mon, 03 Feb 2020 17:37:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf 0/4] netfilter: conntrack: allow insertion of clashing entries
Date:   Mon,  3 Feb 2020 17:37:03 +0100
Message-Id: <20200203163707.27254-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series allows conntrack to insert a duplicate conntrack entry
if the reply direction doesn't result in a clash with a different
original connection.

Background:

kubernetes creates load-balancing rules for DNS using
-m statistics, e.g.:
-p udp --dport 53 -m statistics --mode random ... -j DNAT --to-destination x
-p udp --dport 53 -m statistics --mode random ... -j DNAT --to-destination y

When the resolver sends an A and AAAA request back-to-back from
different threads on the same socket, this has a high chance of a connection
tracking clash at insertion time.

This in turn results in a drop of the clashing udp packet which then
results in a 5 second DNS timeout.

The clash cannot be resolved with the current logic because the
two conntracks entries have different NAT transformations, the first one
from s:highport to x.53, the second from s:highport to y.53.

One solution is to change rules to use a consistent mapping, e.g.
using -m cluster or nftables 'jhash' expression.  This would cause
the A and AAAA requests coming from same socket to match the same rule and
thus share the same NAT information.  However, I do not believe this is
a realistic course of action.

This change adds a second clash resolution/drop avoidance step:
A clashing entry will be added anyway provided the reply direction
is unique.

Because this results in duplicate conntrack entries for the original
direction, this comes with strings attached:
1. The clashed entry will only be around for 1 second
2. The clashed entry can only be found in reply direction
   (not inserted for ORIGINAL)
3. The clashed entry is auto-removed once first reply comes in
4  The clashed entry is never assured and can thus be evicted if
   conntrack table becomes full.

Major change since RFC:
1. Do not insert the duplicate/clash in original dir.
2. This implicitly hides the entry from "conntrack -L".
3. use an internal status bit to auto-remove the conntrack
   when first reply comes in.
4. Extend the commit message of last patch to include a
   summary of alternate proposals (and why they did not work out).

I'm sending this for nf rather than nf-next because I consider this
a bug fix, but I am fine if this is deferred for nf-next instead.

Florian Westphal (4):
      netfilter: conntrack: remove two args from resolve_clash
      netfilter: conntrack: place confirm-bit setting in a helper
      netfilter: conntrack: split resolve_clash function
      netfilter: conntrack: allow insertion of clashing entries

 include/linux/rculist_nulls.h                      |   7 +++++
 include/uapi/linux/netfilter/nf_conntrack_common.h |  12 ++++++++-
 net/netfilter/nf_conntrack_core.c                  | 192 ++++++++++++++++------
 net/netfilter/nf_conntrack_proto_udp.c             |  20 ++++++++++--
 4 files changed, 198 insertions(+), 33 deletions(-)

