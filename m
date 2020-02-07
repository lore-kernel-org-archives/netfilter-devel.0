Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8264EC352A2
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F58220715
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgBGLUi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:20:38 -0500
Received: from correo.us.es ([193.147.175.20]:56756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGLUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 06:20:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F13279ED54
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 12:20:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0E93DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 12:20:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DE270DA720; Fri,  7 Feb 2020 12:20:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E777BDA716;
        Fri,  7 Feb 2020 12:20:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 12:20:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C7A8642EF42F;
        Fri,  7 Feb 2020 12:20:34 +0100 (CET)
Date:   Fri, 7 Feb 2020 12:20:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: always init block_offload struct
Message-ID: <20200207112033.vvs653yqtramn6qm@salvia>
References: <20200203120618.2574-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zz6mqenidhcyjfub"
Content-Disposition: inline
In-Reply-To: <20200203120618.2574-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zz6mqenidhcyjfub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2020 at 01:06:18PM +0100, Florian Westphal wrote:
> nftables test case
> tests/shell/testcases/flowtable/0001flowtable_0
> 
> results in a crash. After the refactor, if we leave early via
> nf_flowtable_hw_offload(), then "struct flow_block_offload" is left
> in an uninitialized state, but later users assume its initialised.

Thanks Florian.

I'll apply this variant of your patch, and sorry for this breakage.

--zz6mqenidhcyjfub
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-flowtable-skip-offload-setup-if-disabled.patch"

From 4ad807945211c623235ad2e0cbcea97fcc305b2c Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 3 Feb 2020 13:06:18 +0100
Subject: [PATCH] netfilter: flowtable: skip offload setup if disabled

nftables test case
tests/shell/testcases/flowtable/0001flowtable_0

results in a crash. After the refactor, if we leave early via
nf_flowtable_hw_offload(), then "struct flow_block_offload" is left
in an uninitialized state, but later users assume its initialised.

Fixes: a7965d58ddab02 ("netfilter: flowtable: add nf_flow_table_offload_cmd()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 83e1db37c3b0..06f00cdc3891 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -847,9 +847,6 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	if (!nf_flowtable_hw_offload(flowtable))
-		return 0;
-
 	if (!dev->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
 
@@ -876,6 +873,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo;
 	int err;
 
+	if (!nf_flowtable_hw_offload(flowtable))
+		return 0;
+
 	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
 	if (err < 0)
 		return err;
-- 
2.11.0


--zz6mqenidhcyjfub--
