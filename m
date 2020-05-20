Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44DAC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7594A20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETSRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:17:00 -0400
Received: from correo.us.es ([193.147.175.20]:43494 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgETSQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:16:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38061DA722
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29B0CDA709
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F6E2DA707; Wed, 20 May 2020 20:16:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34977DA710
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:16:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 202C442EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/7] dynamic device updates for flowtables
Date:   Wed, 20 May 2020 20:16:45 +0200
Message-Id: <20200520181652.30285-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Flowtable allows you to enable a fast forwarding path (packets bypass
the classic forwarding path), eg.

table inet filter {
        flowtable fastpath {
                hook ingress priority 0
                devices = { eth0, eth1 }
        }

        chain forward {
                type filter hook forward priority 0; policy accept;
                ip protocol { tcp , udp } flow offload @fastpath;
        }
}

This ruleset above places TCP and UDP flows in the "fastpath" flowtable.
Flowtables integrate nicely with NAT and lightweight tunnels.

This patchset implements dynamic device updates for flowtables:

Patch #1 generalises the flowtable hook parser to take a hook list.
Patch #2 passes a hook list to the flowtable hook registration/unregistration.
Patch #3 adds a helper function to release the flowtable hook list.
Patch #4 updates the flowtable event notifier to pass a flowtable hook list.
Patch #5 allows users to add new devices to an existing flowtables.
Patch #6 allows users to remove devices to an existing flowtables.
Patch #7 allows to register a flowtable with no initial devices.

This allows users to register a flowtable with no devices:

	nft add flowtable x y { hook ingress priority 0\; }

then, add dynamic devices as they show up:

	nft add flowtable x y { devices = { ppp0, eth1 } \; }

Devices that go away are automagically removed from the flowtable.

Pablo Neira Ayuso (7):
  netfilter: nf_tables: generalise flowtable hook parsing
  netfilter: nf_tables: pass hook list to nft_{un,}register_flowtable_net_hooks()
  netfilter: nf_tables: add nft_flowtable_hooks_destroy()
  netfilter: nf_tables: pass hook list to flowtable event notifier
  netfilter: nf_tables: add devices to existing flowtable
  netfilter: nf_tables: delete devices from flowtable
  netfilter: nf_tables: allow to register flowtable with no devices

 include/net/netfilter/nf_tables.h |   7 +
 net/netfilter/nf_tables_api.c     | 304 ++++++++++++++++++++++++------
 2 files changed, 253 insertions(+), 58 deletions(-)

-- 
2.20.1

