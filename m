Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3353C10DCE
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 13:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC12205C9
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 13:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgCONgc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 09:36:32 -0400
Received: from correo.us.es ([193.147.175.20]:33824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgCONgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 09:36:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 70A6511EB20
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2020 14:36:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 611E2DA3C3
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2020 14:36:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56D25DA736; Sun, 15 Mar 2020 14:36:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E3A4DA736;
        Sun, 15 Mar 2020 14:36:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Mar 2020 14:36:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 513FA4251480;
        Sun, 15 Mar 2020 14:36:02 +0100 (CET)
Date:   Sun, 15 Mar 2020 14:36:28 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: cache: Fix iptables-save segfault under
 stress
Message-ID: <20200315133628.5lyaqfdbbn7kpups@salvia>
References: <20200313174206.32636-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313174206.32636-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 13, 2020 at 06:42:06PM +0100, Phil Sutter wrote:
> If kernel ruleset is constantly changing, code called by
> nft_is_table_compatible() may crash: For each item in table's chain
> list, nft_is_chain_compatible() is called. This in turn calls
> nft_build_cache() to fetch chain's rules. Though if kernel genid has changed
> meanwhile, cache is flushed and rebuilt from scratch, thereby freeing
> table's chain list - the foreach loop in nft_is_table_compatible() then
> operates on freed memory.
> 
> A simple reproducer (may need a few calls):
> 
> | RULESET='*filter
> | :INPUT ACCEPT [10517:1483527]
> | :FORWARD ACCEPT [0:0]
> | :OUTPUT ACCEPT [1714:105671]
> | COMMIT
> | '
> |
> | for ((i = 0; i < 100; i++)); do
> |         iptables-nft-restore <<< "$RULESET" &
> | done &
> | iptables-nft-save
> 
> To fix the problem, basically revert commit ab1cd3b510fa5 ("nft: ensure
> cache consistency") so that __nft_build_cache() no longer flushes the
> cache. Instead just record kernel's genid when fetching for the first
> time. If kernel rule set changes until the changes are committed, the
> commit simply fails and local cache is being rebuilt.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Pablo,
> 
> This is a similar situation as with commit c550c81fd373e ("nft: cache:
> Fix nft_release_cache() under stress"): Your caching rewrite avoids this
> problem as well, but kills some of my performance improvements. I'm
> currently working on restoring them with your approach but that's not a
> quick "fix". Can we go with this patch until I'm done?

Fair enough.
