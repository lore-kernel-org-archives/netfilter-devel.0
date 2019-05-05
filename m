Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C0EC04AAB
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F392082F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfEEMP6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 08:15:58 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56754 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfEEMP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 08:15:58 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x45CFi1d016484;
        Sun, 5 May 2019 15:15:44 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x45CFePD016483;
        Sun, 5 May 2019 15:15:40 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: [PATCHv2 net-next 0/3] Add UDP tunnel support for ICMP errors in IPVS
Date:   Sun,  5 May 2019 15:14:37 +0300
Message-Id: <20190505121440.16389-1-ja@ssi.bg>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patchset is a followup to the commit that adds UDP/GUE tunnel:
"ipvs: allow tunneling with gue encapsulation".

What we do is to put tunnel real servers in hash table (patch 1),
add function to lookup tunnels (patch 2) and use it to strip the
embedded tunnel headers from ICMP errors (patch 3).

v1->v2:
patch 1: remove extra parentheses
patch 2: remove extra parentheses
patch 3: parse UDP header into ipvs_udp_decap
patch 3: v1 ignores forwarded ICMP errors for UDP, do not do that
patch 3: add comment for fragment check

Julian Anastasov (3):
  ipvs: allow rs_table to contain different real server types
  ipvs: add function to find tunnels
  ipvs: strip udp tunnel headers from icmp errors

 include/net/ip_vs.h             |  6 +++
 net/netfilter/ipvs/ip_vs_core.c | 68 +++++++++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_ctl.c  | 72 +++++++++++++++++++++++++++++----
 3 files changed, 138 insertions(+), 8 deletions(-)

-- 
2.17.1

