Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BBCC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3292072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKOL2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:28:04 -0500
Received: from correo.us.es ([193.147.175.20]:48046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfKOL2D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 06:28:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE4C8E2C4E
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 12:27:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C32B3A7EE6
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 12:27:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0003E1B354F; Fri, 15 Nov 2019 12:27:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8C381B354F;
        Fri, 15 Nov 2019 12:27:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 12:27:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8493341E4800;
        Fri, 15 Nov 2019 12:27:50 +0100 (CET)
Date:   Fri, 15 Nov 2019 12:27:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: check the bind callback
 failed and unbind callback if hook register failed
Message-ID: <20191115112752.fqz7h7llwwfllkwy@salvia>
References: <1573816886-2743-1-git-send-email-wenxu@ucloud.cn>
 <20191115112501.6xb5adufqxlb6vnu@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2qw2l7pp3u4eryfa"
Content-Disposition: inline
In-Reply-To: <20191115112501.6xb5adufqxlb6vnu@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2qw2l7pp3u4eryfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2019 at 12:25:01PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 15, 2019 at 07:21:26PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Undo the callback binding before unregistering the existing hooks. It also
> > should check err of the bind setup call
> > 
> > Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> > This patch is based on:
> > http://patchwork.ozlabs.org/patch/1195539/
> 
> This is actually like this one:
> 
> https://patchwork.ozlabs.org/patch/1194046/
> 
> right?

I'm attaching the one I made based on yours that I posted yesterday.

--2qw2l7pp3u4eryfa
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-unbind-callbacks-if-flowtable-ho.patch"

From f070db9a7fb9ecb6d2fdbd4702eb5e29b2bd5f64 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 15 Nov 2019 00:22:55 +0100
Subject: [PATCH] netfilter: nf_tables: unbind callbacks if flowtable hook
 registration fails

Undo the callback binding before unregistering the existing hooks.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f0d880a8496..bd453c28a5d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6009,8 +6009,12 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_BIND);
 		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0)
+		if (err < 0) {
+			flowtable->data.type->setup(&flowtable->data,
+						    hook->ops.dev,
+						    FLOW_BLOCK_UNBIND);
 			goto err_unregister_net_hooks;
+		}
 
 		i++;
 	}
-- 
2.11.0


--2qw2l7pp3u4eryfa--
