Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73560C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5339F22519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfKTNTD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:03 -0500
Received: from correo.us.es ([193.147.175.20]:49272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfKTNTC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F498130E28
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00671B7FF9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EA376B7FF6; Wed, 20 Nov 2019 14:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02830DA8E8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DD49B42EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/7] nf_tables encapsulation/decapsulation support
Date:   Wed, 20 Nov 2019 14:18:47 +0100
Message-Id: <20191120131854.308740-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset introduces new infrastructure to specify protocol
decapsulation and encapsulation actions. This patchset comes with
initial support for VLAN.

1) VLAN decapsulation:

        ... meta iif . vlan id { eth0 . 10, eth1 . 11} decap vlan

The decapsulation action is represented as a single statement with no
extra options.

2) VLAN encapsulation:

        add vlan "network0" { id 100; proto 0x8100; }
        add vlan "network1" { id 101; }
        ... encap vlan push ip daddr map { 192.168.0.0/24 : "network0",
                                           192.168.1.0/24 : "network1" }

The idea is that the user specifies the vlan encapsulation through
object definition, eg. "network0" and "network1", then it applies this
policy via the "encap vlan push/update" statement.

This infrastructure should allow for more encapsulation protocols
with little work, eg. MPLS.

I have placed the encap object and the decap expression in the same
nft_encap module for simplificity.

Patchset is composed of initial updates to allow to specify operation
type on objects:

1) Rename NFTA_OBJREF_IMM_TYPE to NFTA_OBJREF_TYPE.
2) Check for object type from map reference.
3 and 4) Add nft_object_ref and update code to use it.
5) Add support for operations on object reference.

Then, the actual decapsulation / encapsulation support:

6) Add decapsulation support though expression.
7) Add encapsulation support through object definition, this uses
   the operation when referencing the object from rule to specificy
   if this is a update or push vlan operation.

Userspace patchset update is still in progress, comments welcome.
Thanks.

Pablo Neira Ayuso (7):
  netfilter: nft_objref: rename NFTA_OBJREF_IMM_TYPE to NFTA_OBJREF_TYPE
  netfilter: nft_objref: validate map object type
  netfilter: nft_objref: add nft_obj_ref structure and use it
  netfilter: nf_tables: pass nft_object_ref to object evaluation function
  netfilter: nft_objref: add support for operation on objects
  netfilter: nf_tables: add decapsulation support
  netfilter: nf_tables: add encapsulation support

 include/net/netfilter/nf_tables.h        |  10 +-
 include/uapi/linux/netfilter/nf_tables.h |  64 +++++-
 net/netfilter/Kconfig                    |   6 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            |   3 +-
 net/netfilter/nft_connlimit.c            |   4 +-
 net/netfilter/nft_counter.c              |   4 +-
 net/netfilter/nft_ct.c                   |  12 +-
 net/netfilter/nft_encap.c                | 333 +++++++++++++++++++++++++++++++
 net/netfilter/nft_limit.c                |   8 +-
 net/netfilter/nft_meta.c                 |   5 +-
 net/netfilter/nft_objref.c               |  69 +++++--
 net/netfilter/nft_quota.c                |   3 +-
 net/netfilter/nft_synproxy.c             |   4 +-
 net/netfilter/nft_tunnel.c               |   4 +-
 15 files changed, 486 insertions(+), 44 deletions(-)
 create mode 100644 net/netfilter/nft_encap.c

-- 
2.11.0

