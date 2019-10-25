Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EB5CA9EBD
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 11:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B3921D81
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 11:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438745AbfJYLM1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 07:12:27 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33356 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJYLM1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 07:12:27 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 164F025B820;
        Fri, 25 Oct 2019 22:12:25 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 71847376C; Fri, 25 Oct 2019 13:12:20 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
Subject: [GIT PULL] IPVS fixes for v5.4
Date:   Fri, 25 Oct 2019 13:12:03 +0200
Message-Id: <20191025111205.30555-1-horms@verge.net.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

please consider these IPVS fixes for v5.4.

* Eric Dumazet resolves a race condition in switching the defense level

* Davide Caratti resolves a race condition in module removal

This pull request is based on nf.


The following changes since commit 085461c8976e6cb4d5b608a7b7062f394c51a253:

  netfilter: nf_tables_offload: restore basechain deletion (2019-10-23 13:14:50 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git tags/ipvs-fixes-for-v5.4

for you to fetch changes up to c24b75e0f9239e78105f81c5f03a751641eb07ef:

  ipvs: move old_secure_tcp into struct netns_ipvs (2019-10-24 11:56:02 +0200)

----------------------------------------------------------------
Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Eric Dumazet (1):
      ipvs: move old_secure_tcp into struct netns_ipvs

 include/net/ip_vs.h              |  1 +
 net/netfilter/ipvs/ip_vs_app.c   | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 29 +++++++++++------------------
 net/netfilter/ipvs/ip_vs_pe.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c  | 13 ++++++++++---
 6 files changed, 36 insertions(+), 25 deletions(-)
