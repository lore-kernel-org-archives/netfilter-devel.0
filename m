Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F90C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C981220828
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF1Rlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:41:36 -0400
Received: from mail.us.es ([193.147.175.20]:52736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfF1Rlf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B616C1B2B62
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A94914E548
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9EE87203F9; Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4071DDA704;
        Fri, 28 Jun 2019 19:41:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:41:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.195.66])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EC06D4265A32;
        Fri, 28 Jun 2019 19:41:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/4] Netfilter/IPVS fixes for net
Date:   Fri, 28 Jun 2019 19:41:21 +0200
Message-Id: <20190628174125.20739-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix memleak reported by syzkaller when registering IPVS hooks,
   patch from Julian Anastasov.

2) Fix memory leak in start_sync_thread, also from Julian.

3) Fix conntrack deletion via ctnetlink, from Felix Kaechele.

4) Fix reject for ICMP due to incorrect checksum handling, from
   He Zhe.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 85f9aa7565bd79b039325f2c01af7ffa717924df:

  inet: clear num_timeout reqsk_alloc() (2019-06-19 17:46:57 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 5d1549847c76b1ffcf8e388ef4d0f229bdd1d7e8:

  netfilter: Fix remainder of pseudo-header protocol 0 (2019-06-28 19:30:50 +0200)

----------------------------------------------------------------
Felix Kaechele (1):
      netfilter: ctnetlink: Fix regression in conntrack entry deletion

He Zhe (1):
      netfilter: Fix remainder of pseudo-header protocol 0

Julian Anastasov (2):
      ipvs: defer hook registration to avoid leaks
      ipvs: fix tinfo memory leak in start_sync_thread

 include/net/ip_vs.h                     |   6 +-
 net/netfilter/ipvs/ip_vs_core.c         |  21 +++--
 net/netfilter/ipvs/ip_vs_ctl.c          |   4 -
 net/netfilter/ipvs/ip_vs_sync.c         | 134 +++++++++++++++++---------------
 net/netfilter/nf_conntrack_netlink.c    |   7 +-
 net/netfilter/nf_conntrack_proto_icmp.c |   2 +-
 net/netfilter/nf_nat_proto.c            |   2 +-
 net/netfilter/utils.c                   |   5 +-
 8 files changed, 99 insertions(+), 82 deletions(-)

