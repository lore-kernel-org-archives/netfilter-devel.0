Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B64AC7618E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 10:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjDUK5G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 06:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDUK5F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 06:57:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88D9183FC;
        Fri, 21 Apr 2023 03:57:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Fri, 21 Apr 2023 12:56:58 +0200
Message-Id: <20230421105700.325438-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains late Netfilter fixes for net:

1) Set on IPS_CONFIRMED before change_status() otherwise EBUSY is
   bogusly hit. This bug was introduced in the 6.3 release cycle.

2) Fix nfnetlink_queue conntrack support: Set/dump timeout
   accordingly for unconfirmed conntrack entries. Make sure this
   is done after IPS_CONFIRMED is set on. This is an old bug, it
   happens since the introduction of this feature.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-04-21

Thanks.

----------------------------------------------------------------

The following changes since commit 92e8c732d8518588ac34b4cb3feaf37d2cb87555:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2023-04-18 20:46:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-04-21

for you to fetch changes up to 73db1b8f2bb6725b7391e85aab41fdf592b3c0c1:

  netfilter: conntrack: fix wrong ct->timeout value (2023-04-19 12:08:38 +0200)

----------------------------------------------------------------
netfilter pull request

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()

Tzung-Bi Shih (1):
      netfilter: conntrack: fix wrong ct->timeout value

 include/net/netfilter/nf_conntrack_core.h |  6 +++++-
 net/netfilter/nf_conntrack_bpf.c          |  1 +
 net/netfilter/nf_conntrack_core.c         |  1 -
 net/netfilter/nf_conntrack_netlink.c      | 16 ++++++++++++----
 4 files changed, 18 insertions(+), 6 deletions(-)
