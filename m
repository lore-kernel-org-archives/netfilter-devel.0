Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FBAC072A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 18:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjKOSpX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 13:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjKOSpX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 13:45:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C796D46;
        Wed, 15 Nov 2023 10:45:19 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Wed, 15 Nov 2023 19:45:08 +0100
Message-Id: <20231115184514.8965-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Remove unused variable causing compilation warning in nft_set_rbtree,
   from Yang Li. This unused variable is a left over from previous
   merge window.

2) Possible return of uninitialized in nf_conntrack_bridge, from
   Linkui Xiao. This is there since nf_conntrack_bridge is available.

3) Fix incorrect pointer math in nft_byteorder, from Dan Carpenter.
   Problem has been there since 2016.

4) Fix bogus error in destroy set element command. Problem is there
   since this new destroy command was added.

5) Fix race condition in ipset between swap and destroy commands and
   add/del/test control plane. This problem is there since ipset was
   merged.

6) Split async and sync catchall GC in two function to fix unsafe
   iteration over RCU. This is a fix-for-fix that was included in
   the previous pull request.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-11-15

Thanks.

----------------------------------------------------------------

The following changes since commit 4b7b492615cf3017190f55444f7016812b66611d:

  af_unix: fix use-after-free in unix_stream_read_actor() (2023-11-14 10:51:13 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-11-15

for you to fetch changes up to 8837ba3e58ea1e3d09ae36db80b1e80853aada95:

  netfilter: nf_tables: split async and sync catchall in two functions (2023-11-14 16:16:21 +0100)

----------------------------------------------------------------
netfilter pull request 23-11-15

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()

Jozsef Kadlecsik (1):
      netfilter: ipset: fix race condition between swap/destroy and kernel side add/del/test

Linkui Xiao (1):
      netfilter: nf_conntrack_bridge: initialize err to 0

Pablo Neira Ayuso (2):
      netfilter: nf_tables: bogus ENOENT when destroying element which does not exist
      netfilter: nf_tables: split async and sync catchall in two functions

Yang Li (1):
      netfilter: nft_set_rbtree: Remove unused variable nft_net

 include/net/netfilter/nf_tables.h          |  4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |  2 +-
 net/netfilter/ipset/ip_set_core.c          | 14 +++----
 net/netfilter/nf_tables_api.c              | 60 ++++++++++++++++--------------
 net/netfilter/nft_byteorder.c              |  5 ++-
 net/netfilter/nft_meta.c                   |  2 +-
 net/netfilter/nft_set_rbtree.c             |  2 -
 7 files changed, 47 insertions(+), 42 deletions(-)
