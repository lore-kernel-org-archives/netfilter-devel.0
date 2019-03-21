Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA97C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF71B218D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfCUL2y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:28:54 -0400
Received: from mail.us.es ([193.147.175.20]:42668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfCUL2x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:28:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93538C22FF
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7775BBAAA7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 73E44BAAAE; Thu, 21 Mar 2019 12:28:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E726BAAA7;
        Thu, 21 Mar 2019 12:28:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Mar 2019 12:28:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [195.39.71.253])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D08BB4265A4E;
        Thu, 21 Mar 2019 12:28:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/9] Netfilter fixes for net
Date:   Thu, 21 Mar 2019 12:28:36 +0100
Message-Id: <20190321112845.10627-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) Remove a direct dependency with IPv6 introduced by the
   sip_external_media feature, from Alin Nastac.

2) Fix bogus ENOENT when removing interval elements from set.

3) Set transport_header from br_netfilter to mimic the stack
   behaviour, this partially fixes a checksum validation bug
   from the SCTP connection tracking, from Xin Long.

4) Fix undefined reference to symbol in xt_TEE, due to missing
   Kconfig dependencies, from Arnd Bergmann.

5) Check for NULL in skb_header_pointer() calls in ip6t_shr,
   from Kangjie Lu.

6) Fix bogus EBUSY when removing an existing conntrack helper from
   a transaction.

7) Fix module autoload of the redirect extension.

8) Remove duplicated transition in flowtable diagram in the existing
   documentation.

9) Missing .release_ops call from error path in newrule() which
   results module refcount leak, from Taehee Yoo.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 4ec850e5dfec092b26cf3b7d5a6c9e444ea4babd:

  net: dwmac-sun8i: fix a missing check of of_get_phy_mode (2019-03-12 14:52:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b25a31bf0ca091aa8bdb9ab329b0226257568bbe:

  netfilter: nf_tables: add missing ->release_ops() in error path of newrule() (2019-03-20 08:32:58 +0100)

----------------------------------------------------------------
Alin Nastac (1):
      netfilter: nf_conntrack_sip: remove direct dependency on IPv6

Arnd Bergmann (1):
      netfilter: fix NETFILTER_XT_TARGET_TEE dependencies

Kangjie Lu (1):
      netfilter: ip6t_srh: fix NULL pointer dereferences

Pablo Neira Ayuso (4):
      netfilter: nft_set_rbtree: check for inactive element after flag mismatch
      netfilter: nf_tables: bogus EBUSY in helper removal from transaction
      netfilter: nft_redir: fix module autoload with ip4
      netfilter: nf_flowtable: remove duplicated transition in diagram

Taehee Yoo (1):
      netfilter: nf_tables: add missing ->release_ops() in error path of newrule()

Xin Long (1):
      netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING

 Documentation/networking/nf_flowtable.txt |  8 +++----
 net/bridge/br_netfilter_hooks.c           |  1 +
 net/bridge/br_netfilter_ipv6.c            |  2 ++
 net/ipv6/netfilter/ip6t_srh.c             |  6 +++++
 net/netfilter/Kconfig                     |  1 +
 net/netfilter/nf_conntrack_sip.c          | 37 +++++++++++++------------------
 net/netfilter/nf_tables_api.c             |  5 ++++-
 net/netfilter/nft_objref.c                | 19 +++++++++++++---
 net/netfilter/nft_redir.c                 |  2 +-
 net/netfilter/nft_set_rbtree.c            |  7 +++---
 10 files changed, 54 insertions(+), 34 deletions(-)
