Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E90BAC32793
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 10:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjARKtd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 05:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjARKsa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 05:48:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C13032E0EA;
        Wed, 18 Jan 2023 01:54:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/1] Netfilter fixes for net
Date:   Wed, 18 Jan 2023 10:54:23 +0100
Message-Id: <20230118095424.885014-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix syn-retransmits until initiator gives up when connection is re-used
   due to rst marked as invalid, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1f3bd64ad921f051254591fbed04fd30b306cde6:

  net: stmmac: fix invalid call to mdiobus_get_phy() (2023-01-17 13:33:19 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c410cb974f2ba562920ecb8492ee66945dcf88af:

  netfilter: conntrack: handle tcp challenge acks during connection reuse (2023-01-17 23:00:06 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: handle tcp challenge acks during connection reuse

 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
