Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81210C25B6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 10:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjJYKIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 06:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbjJYKI3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 06:08:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8021710A;
        Wed, 25 Oct 2023 03:08:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Wed, 25 Oct 2023 12:08:17 +0200
Message-Id: <20231025100819.2664-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patch contains two late Netfilter's flowtable fixes for net:

1) Flowtable GC pushes back packets to classic path in every GC run,
   ie. every second. This is because NF_FLOW_HW_ESTABLISHED is only
   used by sched/act_ct (never set) and IPS_SEEN_REPLY might be unset
   by the time the flow is offloaded (this status bit is only reliable
   in the sched/act_ct datapath).

2) sched/act_ct logic to push back packets to classic path to reevaluate
   if UDP flow is unidirectional only applies if IPS_HW_OFFLOAD_BIT is
   set on and no hardware offload request is pending to be handled.
   From Vlad Buslov.

These two patches fixes two problems that were introduced in the
previous 6.5 development cycle.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-10-25

Thanks.

----------------------------------------------------------------

The following changes since commit d2a0fc372aca561556e765d0a9ec365c7c12f0ad:

  tcp: fix wrong RTO timeout when received SACK reneging (2023-10-22 11:47:44 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-10-25

for you to fetch changes up to a63b6622120cd03a304796dbccb80655b3a21798:

  net/sched: act_ct: additional checks for outdated flows (2023-10-25 11:35:57 +0200)

----------------------------------------------------------------
netfilter pull request 23-10-25

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: flowtable: GC pushes back packets to classic path

Vlad Buslov (1):
      net/sched: act_ct: additional checks for outdated flows

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 14 +++++++-------
 net/sched/act_ct.c                    |  9 +++++++++
 3 files changed, 17 insertions(+), 7 deletions(-)
