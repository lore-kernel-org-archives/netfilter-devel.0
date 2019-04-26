Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608FFC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F8D206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfDZRFY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:05:24 -0400
Received: from mail.us.es ([193.147.175.20]:32798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfDZRFY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:05:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C6A01031AE
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:05:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E6C6DA706
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:05:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 83F41DA704; Fri, 26 Apr 2019 19:05:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D195DA701;
        Fri, 26 Apr 2019 19:05:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 19:05:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B5924265A31;
        Fri, 26 Apr 2019 19:05:20 +0200 (CEST)
Date:   Fri, 26 Apr 2019 19:05:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables-nft 0/6] handle parallel restore case
Message-ID: <20190426170520.qk66dcxg4uwisleh@salvia>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 23, 2019 at 03:16:19PM +0200, Florian Westphal wrote:
> This series handles the case of parallel iptables-nft-restore
> invocations.
> 
> As xtables-nft ignores -w option (userspace-based serialization
> lock), several nft instances can race.
> 
> In worse case, we can restore a ruleset twice, i.e. we get
> duplicated rules:
> 
> 1. "iptables-nft-restore < foo" is called for first time.
>    No tables exist, so we create a transaction that creates
>    the table/chains/rules.
> 2. "iptables-nft-restore < foo" is called in parallel.
>    If the timing is right, it will also find no existing table,
>    and will create a 2nd batch that adds rules.
> 
>    If the 2nd version doesn't run in parallel, it will detect
>    that the table exists and will add a flush operation to the
>    batch.
> 
> The first patches are preparation work, the fix is coming in patch 5,
> it uses the generation counter to detect when the transaction batch
> was based off an old state.
> 
> In case kernel indicates the generation id doesn't match anymore,
> we fetch the current state and will refresh the pending transaction
> before re-try.
> 
> The refresh currently includes adding/removing flush and chain add
> operations.
> 
> Last patch adds a test script for this.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
