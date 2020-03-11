Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0949C10F27
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C0B21D7E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgCKON0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:13:26 -0400
Received: from correo.us.es ([193.147.175.20]:59624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgCKONZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:13:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3810DA393
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3C85DA3C4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E2B4BDA3C2; Wed, 11 Mar 2020 15:13:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27ECCDA840
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:13:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 13DE742EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/4] enhance stateful expression support
Date:   Wed, 11 Mar 2020 15:13:14 +0100
Message-Id: <20200311141318.3633-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset allows users to add and to restore stateful expressions
of set elements, e.g.

 table ip test {
        set test {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                timeout 30d
                gc-interval 1d
                elements = { 192.168.10.13 expires 19d23h52m27s576ms counter packets 51 bytes 17265 }
        }
        chain output {
                type filter hook output priority 0;
                update @test { ip saddr }
        }
 }

You can also add counters to elements from the control place, ie.

 table ip test {
        set test {
                type ipv4_addr
                size 65535
                elements = { 192.168.2.1 counter packets 75 bytes 19043 }
        }

        chain output {
                type filter hook output priority filter; policy accept;
                ip daddr @test
        }
 }

Thanks.

Pablo Neira Ayuso (4):
  netfilter: nf_tables: remove EXPORT_SYMBOL_GPL for nft_expr_init()
  netfilter: nf_tables: add elements with stateful expressions
  netfilter: nf_tables: add nft_set_elem_update_expr() helper function
  netfilter: nft_lookup: update element stateful expression

 include/net/netfilter/nf_tables.h | 14 ++++++++++++--
 net/netfilter/nf_tables_api.c     | 25 ++++++++++++++++++++++---
 net/netfilter/nft_dynset.c        |  8 +-------
 net/netfilter/nft_lookup.c        |  1 +
 4 files changed, 36 insertions(+), 12 deletions(-)

--
2.11.0

