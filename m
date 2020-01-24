Return-Path: <SRS0=/v6G=3N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C43C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 19:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310EC20702
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 19:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391581AbgAXTy2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 14:54:28 -0500
Received: from correo.us.es ([193.147.175.20]:32966 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389023AbgAXTy2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 14:54:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FACA15AEA6
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2020 20:54:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80B87DA716
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2020 20:54:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7588ADA705; Fri, 24 Jan 2020 20:54:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB016DA713;
        Fri, 24 Jan 2020 20:54:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Jan 2020 20:54:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F5BF42EE38E;
        Fri, 24 Jan 2020 20:54:24 +0100 (CET)
Date:   Fri, 24 Jan 2020 20:54:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nf_tables_offload: fix check the chain
 offload flag
Message-ID: <20200124195421.5d6eyvl6f5z3nhxv@salvia>
References: <1579411110-3187-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579411110-3187-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 19, 2020 at 01:18:30PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the nft_indr_block_cb the chain should check the flag with
> NFT_CHAIN_HW_OFFLOAD.

Applied.
