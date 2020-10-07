Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1725FC4363D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 23:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB602083B
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 23:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgJGXO5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 19:14:57 -0400
Received: from correo.us.es ([193.147.175.20]:45468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgJGXO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 19:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14D5CE4B88
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 058E9DA789
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF55ADA73D; Thu,  8 Oct 2020 01:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C85A6DA789
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 08 Oct 2020 01:14:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B3C3042EF42A
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/4] Add nf_tables ingress hook for the inet family
Date:   Thu,  8 Oct 2020 01:14:44 +0200
Message-Id: <20201007231448.27346-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset adds support for the inet ingress hook:

Patch #1 adds nf_static_key_inc() and nf_static_key_dec() helper functions.
Patch #2 adds nf_ingress_hook() helper function.
Patch #3 adds inet ingress hook support to the core.
Patch #4 adds inet ingress hook support for nf_tables.

The following example shows how to place offenders into the 'blackhole'
set. Offenders in this case are those that connect to the local SSH port
over the specified rate limit. The inet ingress chain is used to
shortcircuit the evaluation of the traffic coming from the offender at
early stage in the packet processing receive path.

  table inet filter {
        set blackhole {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                timeout 5m
        }

        chain input {
                type filter hook input priority filter; policy accept;
                ct state new tcp dport 22 update @blackhole { ip saddr limit rate over 4/minute } counter packets 0 bytes 0
        }

        chain ingress {
                type filter hook unknown device "enp0s25" priority filter; policy accept;
                ip saddr @blackhole counter packets 0 bytes 0 drop
        }
  }

Pablo Neira Ayuso (4):
  netfilter: add nf_static_key_{inc,dec}
  netfilter: add nf_ingress_hook() helper function
  netfilter: add inet ingress support
  netfilter: nf_tables: add inet ingress support

 include/net/netfilter/nf_tables.h      |   6 ++
 include/net/netfilter/nf_tables_ipv4.h |  33 +++++++
 include/net/netfilter/nf_tables_ipv6.h |  46 +++++++++
 include/uapi/linux/netfilter.h         |   1 +
 net/netfilter/core.c                   | 127 ++++++++++++++++++++-----
 net/netfilter/nf_tables_api.c          |  14 +--
 net/netfilter/nft_chain_filter.c       |  35 ++++++-
 7 files changed, 228 insertions(+), 34 deletions(-)

--
2.20.1

