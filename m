Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9D8C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5CA02073B
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCELt3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:49:29 -0500
Received: from correo.us.es ([193.147.175.20]:38042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgCELt3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 06:49:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2178C1176CE
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2020 12:49:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14770FC55A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2020 12:49:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A1A7DA72F; Thu,  5 Mar 2020 12:49:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B98FDA7B6;
        Thu,  5 Mar 2020 12:49:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Mar 2020 12:49:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0BE5442EF4E1;
        Thu,  5 Mar 2020 12:49:10 +0100 (CET)
Date:   Thu, 5 Mar 2020 12:49:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix infinite loop when expr is
 not available
Message-ID: <20200305114925.3b2yb2mazre5ti6c@salvia>
References: <20200305101536.13029-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305101536.13029-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 05, 2020 at 11:15:36AM +0100, Florian Westphal wrote:
> nft will loop forever if the kernel doesn't support an expression:
> 
> 1. nft_expr_type_get() appends the family specific name to the module list.
> 2. -EAGAIN is returned to nfnetlink, nfnetlink calls abort path.
> 3. abort path sets ->done to true and calls request_module for the
>    expression.
> 4. nfnetlink replays the batch, we end up in nft_expr_type_get() again.
> 5. nft_expr_type_get attempts to append family-specific name. This
>    one already exists on the list, so we continue
> 6. nft_expr_type_get adds the generic expression name to the module
>    list. -EAGAIN is returned, nfnetlink calls abort path.
> 7. abort path encounters the family-specific expression which
>    has 'done' set, so it gets removed.
> 8. abort path requests the generic expression name, sets done to true.
> 9. batch is replayed.
> 
> If the expression could not be loaded, then we will end up back at 1),
> because the family-specific name got removed and the cycle starts again.
> 
> Note that userspace can SIGKILL the nft process to stop the cycle, but
> the desired behaviour is to return an error after the generic expr name
> fails to load the expression.

Applied, thanks Florian.
