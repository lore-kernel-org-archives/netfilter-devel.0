Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C099C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 22:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293CC222A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 22:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRWDQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 17:03:16 -0500
Received: from correo.us.es ([193.147.175.20]:53750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfKRWDQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 17:03:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7703580FED
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 23:03:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69D3A202AE
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 23:03:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5F9A6DA8E8; Mon, 18 Nov 2019 23:03:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9537CDA801;
        Mon, 18 Nov 2019 23:03:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 23:03:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7106A42EE38E;
        Mon, 18 Nov 2019 23:03:08 +0100 (CET)
Date:   Mon, 18 Nov 2019 23:03:10 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/4] netfilter: nft_tunnel: support tunnel
 match expr offload
Message-ID: <20191118220310.bp24erhewr2uetbp@salvia>
References: <1573890564-16500-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573890564-16500-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 16, 2019 at 03:49:20PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series add NFT_TUNNEL_IPV4/6_SRC/DST match and tunnel expr offload.

Thanks. Please, let me revamp a new patch series for the
encapsulation/decapsulation support to make sure those are mixing well
with your tunnel matching support.

> wenxu (4):
>   netfilter: nft_tunnel: add nft_tunnel_mode_match function
>   netfilter: nft_tunnel: support NFT_TUNNEL_IPV4_SRC/DST match
>   netfilter: nft_tunnel: support NFT_TUNNEL_IPV6_SRC/DST match
>   netfilter: nft_tunnel: add nft_tunnel_get_offload support
> 
>  include/net/netfilter/nf_tables_offload.h |   5 ++
>  include/uapi/linux/netfilter/nf_tables.h  |   4 +
>  net/netfilter/nft_tunnel.c                | 138 +++++++++++++++++++++++++++---
>  3 files changed, 134 insertions(+), 13 deletions(-)
> 
> -- 
> 1.8.3.1
> 
