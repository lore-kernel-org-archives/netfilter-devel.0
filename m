Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0E1C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C0C3205ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEEW1p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 18:27:45 -0400
Received: from mail.us.es ([193.147.175.20]:50460 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfEEW1p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 18:27:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAE98DA70A
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:27:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A5C2DA701
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:27:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90103DA703; Mon,  6 May 2019 00:27:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F5E1DA701;
        Mon,  6 May 2019 00:27:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 00:27:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7AFF14265A31;
        Mon,  6 May 2019 00:27:40 +0200 (CEST)
Date:   Mon, 6 May 2019 00:27:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix base chain stat
 rcu_dereference usage
Message-ID: <20190505222740.cj5disqjv5phgv4x@salvia>
References: <20190430123322.6744-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430123322.6744-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 02:33:22PM +0200, Florian Westphal wrote:
> Following splat gets triggered when nfnetlink monitor is running while
> xtables-nft selftests are running:
> 
> net/netfilter/nf_tables_api.c:1272 suspicious rcu_dereference_check() usage!
> other info that might help us debug this:
> 
> 1 lock held by xtables-nft-mul/27006:
>  #0: 00000000e0f85be9 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x1a/0x50
> Call Trace:
>  nf_tables_fill_chain_info.isra.45+0x6cc/0x6e0
>  nf_tables_chain_notify+0xf8/0x1a0
>  nf_tables_commit+0x165c/0x1740
> 
> nf_tables_fill_chain_info() can be called both from dumps (rcu read locked)
> or from the transaction path if a userspace process subscribed to nftables
> notifications.
> 
> In the 'table dump' case, rcu_access_pointer() cannot be used: We do not
> hold transaction mutex so the pointer can be NULLed right after the check.
> Just unconditionally fetch the value, then have the helper return
> immediately if its NULL.
> 
> In the notification case we don't hold the rcu read lock, but updates are
> prevented due to transaction mutex. Use rcu_dereference_check() to make lockdep
> aware of this.

Applied, thanks Florian.
