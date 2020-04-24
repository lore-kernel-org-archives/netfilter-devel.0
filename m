Return-Path: <SRS0=g4y9=6I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9A3C54FD0
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A7320781
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgDXTzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 15:55:45 -0400
Received: from correo.us.es ([193.147.175.20]:46098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXTzp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 15:55:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30414DA738
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20972BAAAF
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1652FDA736; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26DD4DA7B2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Apr 2020 21:55:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 12DA142EF4E0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/5] netmap support for nftables
Date:   Fri, 24 Apr 2020 21:55:32 +0200
Message-Id: <20200424195537.23975-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset adds netmap support for nftables.

Patch #1 Remove the 128-bit limitation on the set element data area.
         Rise it up to 64 bytes maximum.

Patch #2 Return EOPNOTSUPP in case NAT type or flags are not supported.

Patch #3 Initialize NAT flags from control plane.

Patch #4 Add helper functions to set up NAT address and protocol

Patch #5 Add netmap support.

The following example enables source netmap using the 192.168.3.0/24
network address:

 table ip x {
            chain y {
                    type nat hook postrouting priority srcnat; policy accept;
                    snat ip prefix to 192.168.3.0/24
            }
 }

You can also combine it with maps:

 table ip x {
            chain y {
                    type nat hook postrouting priority srcnat; policy accept;
                    snat ip prefix to ip saddr map { 192.168.2.0/24 : 192.168.3.0/24 }
            }
 }

Comments welcome.

Thanks.

Pablo Neira Ayuso (5):
  netfilter: nf_tables: allow up to 64 bytes in the set element data area
  netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported
  netfilter: nft_nat: set flags from initialization path
  netfilter: nft_nat: add helper function to set up NAT address and protocol
  netfilter: nft_nat: add netmap support

 include/net/netfilter/nf_tables.h     |   4 +
 include/uapi/linux/netfilter/nf_nat.h |   4 +-
 net/netfilter/nf_tables_api.c         |  38 ++++++---
 net/netfilter/nft_nat.c               | 110 ++++++++++++++++++++------
 4 files changed, 117 insertions(+), 39 deletions(-)

--
2.20.1

