Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A38C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8DB21775
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 19:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgCBT0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 14:26:08 -0500
Received: from correo.us.es ([193.147.175.20]:43452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBT0I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 14:26:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3EB8303D05
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2020 20:25:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C62F1DA390
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2020 20:25:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BBB66DA38D; Mon,  2 Mar 2020 20:25:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E81E6DA3A0;
        Mon,  2 Mar 2020 20:25:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 20:25:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CAEB8426CCB9;
        Mon,  2 Mar 2020 20:25:51 +0100 (CET)
Date:   Mon, 2 Mar 2020 20:26:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 2/4] nft: cache: Make nft_rebuild_cache()
 respect fake cache
Message-ID: <20200302192604.rzhx4ayog4xqq3ut@salvia>
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302175358.27796-3-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 02, 2020 at 06:53:56PM +0100, Phil Sutter wrote:
> If transaction needed a refresh in nft_action(), restore with flush
> would fetch a full cache instead of merely refreshing table list
> contained in "fake" cache.
> 
> To fix this, nft_rebuild_cache() must distinguish between fake cache and
> full rule cache. Therefore introduce NFT_CL_FAKE to be distinguished
> from NFT_CL_RULES.

Please, refresh me: Why do we need this "fake cache" in first place?
