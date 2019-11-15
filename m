Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12439C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E022620733
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKOVsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 16:48:33 -0500
Received: from correo.us.es ([193.147.175.20]:59762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfKOVsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 16:48:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5141E8637
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:48:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D46557E4DF
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:48:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9E77D1929; Fri, 15 Nov 2019 22:48:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48ED6B8011;
        Fri, 15 Nov 2019 22:48:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 22:48:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 25C1B4251481;
        Fri, 15 Nov 2019 22:48:26 +0100 (CET)
Date:   Fri, 15 Nov 2019 22:48:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: nf_flow_table_offload: support
 tunnel match
Message-ID: <20191115214827.lyu35l2y3nqusplh@salvia>
References: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 15, 2019 at 08:03:26PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide tunnel offload based on route lwtunnel. 
> The first two patches support indr callback setup
> Then add tunnel match and action offload

Could you provide a configuration script for this tunnel setup?

Thanks.

> This patch is based on 
> http://patchwork.ozlabs.org/patch/1194247/
> http://patchwork.ozlabs.org/patch/1195539/
> 
> wenxu (4):
>   netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
>     to support indir setup
>   netfilter: nf_flow_table_offload: add indr block setup support
>   netfilter: nf_flow_table_offload: add tunnel match offload support
>   netfilter: nf_flow_table_offload: add tunnel encap/decap action
>     offload support
> 
>  net/netfilter/nf_flow_table_offload.c | 240 +++++++++++++++++++++++++++++++---
>  1 file changed, 223 insertions(+), 17 deletions(-)
> 
> -- 
> 1.8.3.1
> 
