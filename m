Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D68CC10F29
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA38206EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgCQNNy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:13:54 -0400
Received: from correo.us.es ([193.147.175.20]:51600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgCQNNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 09:13:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4EFB3F23B1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BD15FC5E2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31352FC5E4; Tue, 17 Mar 2020 14:13:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56CDFFC5E2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Mar 2020 14:13:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3984142EE399
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/3] support for stateful expressions in set definition
Date:   Tue, 17 Mar 2020 14:13:43 +0100
Message-Id: <20200317131346.30544-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset allows user to specify a stateful expression in the set
definition, eg.

 table ip x {
        set y {
                typeof ip saddr
                counter
                elements = { 192.168.10.35, 192.168.10.101, 192.168.10.135 }
        }

        chain z {
                type filter hook output priority filter; policy accept;
                ip daddr @y
        }
 }

The example above turns on counters for each element in the set 'y'.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: move nft_expr_clone() to nf_tables_api.c
  netfilter: nf_tables: pass context to nft_set_destroy()
  netfilter: nf_tables: allow to specify stateful expression in set definition

 include/net/netfilter/nf_tables.h        |  3 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 88 ++++++++++++++++++++++++++------
 net/netfilter/nft_dynset.c               | 17 ------
 4 files changed, 76 insertions(+), 34 deletions(-)

--
2.11.0

