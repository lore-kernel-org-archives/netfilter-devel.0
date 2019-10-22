Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40431CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 15:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E985214B2
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 15:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbfJVPrq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:47:46 -0400
Received: from correo.us.es ([193.147.175.20]:41900 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387914AbfJVPrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 11:47:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B6421C4427
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 17:47:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBF80FF6CD
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 17:47:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E15FDB8014; Tue, 22 Oct 2019 17:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA93D9661A;
        Tue, 22 Oct 2019 17:47:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 22 Oct 2019 17:47:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B25AC42EE38E;
        Tue, 22 Oct 2019 17:47:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, wenxu@ucloud.cn
Subject: [PATCH nf-next,RFC 0/2] nf_tables encapsulation/decapsulation support
Date:   Tue, 22 Oct 2019 17:47:31 +0200
Message-Id: <20191022154733.8789-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is a RFC patchset, untested, to introduce new infrastructure to
specify protocol decapsulation and encapsulation actions. This patchset
comes with initial support for VLAN, eg.

1) VLAN decapsulation:

	... meta iif . vlan id { eth0 . 10, eth1 . 11} decap vlan

The decapsulation is a single statement with no extra options.

2) VLAN encapsulation:

	add vlan "network0" { type push; id 100; proto 0x8100; }
        add vlan "network1" { type update; id 101; }
	... encap vlan set ip daddr map { 192.168.0.0/24 : "network0",
					  192.168.1.0/24 : "network1" }

The idea is that the user specifies the vlan policy through object
definition, eg. "network0" and "network1", then it applies this policy
via the "encap vlan set" statement.

This infrastructure should allow for more encapsulation protocols
with little work, eg. MPLS.

I have places the encap object and the decap expression in the same
nft_encap module.

I'm still considering to extend the object infrastructure to specify
the operation type through the rule, ie.

	add vlan "network0" { id 100; proto 0x8100; }
        add vlan "network1" { id 101; }
	... encap vlan push ip daddr map { 192.168.0.0/24 : "network0",
					   192.168.1.0/24 : "network1" }

So the VLAN object does not come with the operation type, instead this
is specified through the encap statement, that would require a bit more
work on the object infrastructure which is probably a good idea.

This is work-in-progress, syntax is tentative, comments welcome.

Thanks.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: add decapsulation support
  netfilter: nf_tables: add encapsulation support

 include/uapi/linux/netfilter/nf_tables.h |  56 ++++-
 net/netfilter/Kconfig                    |   6 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_encap.c                | 341 +++++++++++++++++++++++++++++++
 4 files changed, 403 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nft_encap.c

--
2.11.0

