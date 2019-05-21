Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAACC04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 14:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A982173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 14:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfEUOLa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 10:11:30 -0400
Received: from mail.us.es ([193.147.175.20]:57844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbfEUOL3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 10:11:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09B5610324D
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 16:11:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDD78DA702
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 16:11:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E374FDA704; Tue, 21 May 2019 16:11:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC519DA702;
        Tue, 21 May 2019 16:11:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 May 2019 16:11:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.195.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CB8E44265A31;
        Tue, 21 May 2019 16:11:25 +0200 (CEST)
Date:   Tue, 21 May 2019 16:11:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_fib: Fix existence check support
Message-ID: <20190521141124.ihug3hmsyd53blsy@salvia>
References: <20190515181532.15811-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515181532.15811-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 15, 2019 at 08:15:32PM +0200, Phil Sutter wrote:
> NFTA_FIB_F_PRESENT flag was not always honored since eval functions did
> not call nft_fib_store_result in all cases.
> 
> Given that in all callsites there is a struct net_device pointer
> available which holds the interface data to be stored in destination
> register, simplify nft_fib_store_result() to just accept that pointer
> instead of the nft_pktinfo pointer and interface index. This also
> allows to drop the index to interface lookup previously needed to get
> the name associated with given index.

Applied, thanks.
