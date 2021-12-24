Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48373C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 15:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353092AbhLXPoC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:44:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44496 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353080AbhLXPoB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:44:01 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7564A607C1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 16:41:23 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 0/4] more updates to use libmnl
Date:   Fri, 24 Dec 2021 16:43:47 +0100
Message-Id: <20211224154351.360124-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

This is a follow up in response to your patch series, this is following
a slightly different approach which is to provide two type of helper
functions:

- to build the netlink messages.
- to send request to kernel and process the reply (transport).

I'm integrating your original 3/6 patch into this series:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20211201173253.33432-4-mikhail.sennikovskii@ionos.com/

with a few updates.

Thanks.

Mikhail Sennikovsky (1):
  conntrack: pass sock to nfct_mnl_*() functions

Pablo Neira Ayuso (3):
  conntrack: add nfct_mnl_talk() and nfct_mnl_recv() helper functions
  conntrack: add netlink flags to nfct_mnl_nlmsghdr_put()
  conntrack: use libmnl to create entry

 src/conntrack.c | 175 ++++++++++++++++++++++++++++++------------------
 1 file changed, 109 insertions(+), 66 deletions(-)

-- 
2.30.2

