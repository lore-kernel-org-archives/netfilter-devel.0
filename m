Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC0DFA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25451205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390001AbfJPMej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:34:39 -0400
Received: from correo.us.es ([193.147.175.20]:50962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfJPMei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 08:34:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BF3118CDC6
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EE30A7E1A
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34822A7E23; Wed, 16 Oct 2019 14:34:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E07FA7E1A
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 16 Oct 2019 14:34:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1E3A142EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:34:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/4] flowtable updates
Date:   Wed, 16 Oct 2019 14:34:27 +0200
Message-Id: <20191016123431.9072-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset update the flowtable control plane for nf_tables:

1) Move the priority field to nf_flowtable.

2) Dynamically allocate hooks per net_device.

3) Return EEXIST if a netdevice is twice or more from the same flowtable.

4) Rise limit from 8 to 256 netdevices per flowtable.

Pablo Neira Ayuso (4):
  netfilter: nf_flow_table: move priority to struct nf_flowtable
  netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables
  netfilter: nf_tables: allow only one netdev per flowtable
  netfilter: nf_tables: increase maximum devices number per flowtable

 include/net/netfilter/nf_flow_table.h |   1 +
 include/net/netfilter/nf_tables.h     |  12 +-
 net/netfilter/nf_tables_api.c         | 276 +++++++++++++++++++++-------------
 3 files changed, 180 insertions(+), 109 deletions(-)

-- 
2.11.0

