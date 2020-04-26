Return-Path: <SRS0=Hoda=6K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26902C55194
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D15206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDZNYr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Apr 2020 09:24:47 -0400
Received: from correo.us.es ([193.147.175.20]:42930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgDZNYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Apr 2020 09:24:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73C501BFA81
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 570ECB7FF5
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B043B7FFD; Sun, 26 Apr 2020 15:24:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72511DA788;
        Sun, 26 Apr 2020 15:24:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 15:24:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4F28942EF4E2;
        Sun, 26 Apr 2020 15:24:00 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Date:   Sun, 26 Apr 2020 15:23:53 +0200
Message-Id: <20200426132356.8346-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

This is another turn / incremental update to the pktbuff API based on
your feedback:

Patch #1 adds pktb_alloc_head() to allocate the pkt_buff structure.
	 This patch also adds pktb_build_data() to set up the pktbuff
	 data pointer.

Patch #2 updates the existing example to use pktb_alloc_head() and
         pktb_build_data().

Patch #3 adds a few helper functions to set up the pointer to the
         network header.

Your goal is to avoid the memory allocation and the memcpy() in
pktb_alloc(). With this scheme, users pre-allocate the pktbuff object
from the configuration step, and then this object is recycled for each
packet that is received from the kernel.

Would this update fit for your usecase?

Thanks.

P.S: I'm sorry for the time being, it's been hectic here.

Pablo Neira Ayuso (3):
  pktbuff: add pktb_alloc_head() and pktb_build_data()
  example: nf-queue: use pkt_buff
  pktbuff: add pktb_reset_network_header() and pktb_set_network_header()

 examples/nf-queue.c                  | 25 +++++++++++++++++++--
 include/libnetfilter_queue/pktbuff.h |  6 +++++
 src/extra/pktbuff.c                  | 33 ++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

--
2.20.1

