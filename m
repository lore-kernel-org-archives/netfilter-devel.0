Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AE3C77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 20:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjECUNO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 16:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjECUNN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 16:13:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F5108A67;
        Wed,  3 May 2023 13:12:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/1] Netfilter fixes for net
Date:   Wed,  3 May 2023 22:11:42 +0200
Message-Id: <20230503201143.12310-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains one Netfilter fix:

1) Restore 'ct state untracked' matching with CONFIG_RETPOLINE=y,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6a341729fb31b4c5df9f74f24b4b1c98410c9b87:

  af_packet: Don't send zero-byte data in packet_sendmsg_spkt(). (2023-05-03 09:20:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-03

for you to fetch changes up to f057b63bc11d86a98176de31b437e46789f44d8f:

  netfilter: nf_tables: fix ct untracked match breakage (2023-05-03 13:49:08 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-03

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: fix ct untracked match breakage

 net/netfilter/nft_ct_fast.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)
