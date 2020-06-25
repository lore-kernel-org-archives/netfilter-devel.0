Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A824AC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8299320789
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389705AbgFYSQ7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:16:59 -0400
Received: from correo.us.es ([193.147.175.20]:58808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgFYSQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:16:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2533FFC529
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:16:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15FEADA78D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:16:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15710DA72F; Thu, 25 Jun 2020 20:16:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEF95DA78D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:16:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:16:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D894A42EE395
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:16:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/5] support for anonymous non-base chains in nftables
Date:   Thu, 25 Jun 2020 20:16:46 +0200
Message-Id: <20200625181651.1481-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset extends the nftables netlink API to support for anonymous
non-base chains. Anonymous non-base chains have two properties:

1) The kernel dynamically allocates the (internal) chain name.
2) If the rule that refers to the anonymous chain is removed, then the
   anonymous chain and its content is also released.

This new infrastructure allows for the following syntax from userspace:

 table inet x {
        chain y {
                type filter hook input priority 0;
                tcp dport 22 chain {
                        ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
                        ip6 saddr ::1/128 accept;
                }
        }
 }

The bytecode actually looks like this:

tcp dport 22 chain { ...

  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00001600 ]
  [ immediate reg 0 jump __chain%llu ]

where the anonymous chain block:

  ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
  ip6 saddr ::1/128 accept;

is added to the __chain%llu chain.

The %llu is replaced by a 64-bit identifier which is dynamically
allocated from the kernel. This is actually an incremental 64-bit
chain ID that is used to allocated the internal name.

A few notes:

* The existing approach assumes an implicit jump to chain action for
  implicit chains.

* Depending on the use-case, jumpto chain through dictionary (a.k.a. verdict
  map) provides a more efficient ruleset evaluation.

Pablo Neira Ayuso (5):
  netfilter: nf_tables: add NFTA_CHAIN_ID attribute
  netfilter: nf_tables: add NFTA_RULE_CHAIN_ID attribute
  netfilter: nf_tables: add NFTA_VERDICT_CHAIN_ID attribute
  netfilter: nf_tables: expose enum nft_chain_flags through UAPI
  netfilter: nf_tables: add NFT_CHAIN_ANONYMOUS

 include/net/netfilter/nf_tables.h        |  23 +++--
 include/uapi/linux/netfilter/nf_tables.h |  11 +++
 net/netfilter/nf_tables_api.c            | 117 +++++++++++++++++++----
 net/netfilter/nft_immediate.c            |  54 +++++++++++
 4 files changed, 178 insertions(+), 27 deletions(-)

--
2.20.1

