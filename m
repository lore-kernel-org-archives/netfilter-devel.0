Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5B1C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9A1206F0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 18:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfLBSAE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:00:04 -0500
Received: from correo.us.es ([193.147.175.20]:44986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfLBSAE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 13:00:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 873636EAE8
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:00:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7965DDA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 19:00:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6F322DA70D; Mon,  2 Dec 2019 19:00:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76DF3DA701;
        Mon,  2 Dec 2019 18:59:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 18:59:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5550042EE38F;
        Mon,  2 Dec 2019 18:59:58 +0100 (CET)
Date:   Mon, 2 Dec 2019 18:59:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] segtree: Fix add and delete of element in same batch
Message-ID: <20191202175959.4iiztidbsqk4u7l4@salvia>
References: <20191121104124.23345-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121104124.23345-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 11:41:24AM +0100, Phil Sutter wrote:
> The commit this fixes accidentally broke a rather exotic use-case which
> is but used in set-simple.t of tests/monitor:
> 
> | # nft 'add element t s { 22-25 }; delete element t s { 22-25 }'
> 
> Since ranges are now checked for existence in userspace before delete
> command is submitted to kernel, the second command above was rejected
> because the range in question wasn't present in cache yet. Fix this by
> adding new interval set elements to cache after creating the batch job
> for them.

Applied, with minor glitch:

        if (set->init != NULL &&
            set->flags & NFT_SET_INTERVAL)

Just in case the set definition is empty.

Thanks Phil.
