Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AB1C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB2021479
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfIHQBo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 12:01:44 -0400
Received: from correo.us.es ([193.147.175.20]:49790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfIHQBo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 12:01:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 212AEDA72B
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:01:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 117B8DA4D0
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:01:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07207DA4CA; Sun,  8 Sep 2019 18:01:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA082DA72F;
        Sun,  8 Sep 2019 18:01:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 18:01:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A9D184265A5A;
        Sun,  8 Sep 2019 18:01:37 +0200 (CEST)
Date:   Sun, 8 Sep 2019 18:01:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v6 0/8]  netfilter: nf_tables_offload: support
 tunnel offload
Message-ID: <20190908160139.punl4v3bgdza6dyl@salvia>
References: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only one series at a time, sorry.

On Sun, Sep 08, 2019 at 10:22:00PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series add NFT_TUNNEL_IP/6_SRC/DST match and tunnel expr offload.
> Also add NFTA_TUNNEL_KEY_RELEASE actions adn objref, tunnel obj offload
> 
> This version just rebase to master for patch 7
> 
> wenxu (8):
>   netfilter: nft_tunnel: add nft_tunnel_mode_validate function
>   netfilter: nft_tunnel: support NFT_TUNNEL_IP_SRC/DST match
>   netfilter: nft_tunnel: add ipv6 check in nft_tunnel_mode_validate
>   netfilter: nft_tunnel: support NFT_TUNNEL_IP6_SRC/DST match
>   netfilter: nft_tunnel: support tunnel meta match offload
>   netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
>   netfilter: nft_objref: add nft_objref_type offload
>   netfilter: nft_tunnel: support nft_tunnel_obj offload
> 
>  include/net/netfilter/nf_tables.h         |   4 +
>  include/net/netfilter/nf_tables_offload.h |   5 +
>  include/uapi/linux/netfilter/nf_tables.h  |   5 +
>  net/netfilter/nft_objref.c                |  14 +++
>  net/netfilter/nft_tunnel.c                | 159 +++++++++++++++++++++++++++---
>  5 files changed, 174 insertions(+), 13 deletions(-)
> 
> -- 
> 1.8.3.1
> 
