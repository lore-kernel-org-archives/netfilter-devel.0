Return-Path: <SRS0=tLP1=VJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33735C742B3
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01701208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfGLKmb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:42:31 -0400
Received: from mail.us.es ([193.147.175.20]:46020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfGLKmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 06:42:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BE81C1DE1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2019 12:42:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BC49DA4D0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2019 12:42:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 41599DA4CA; Fri, 12 Jul 2019 12:42:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1F38DA708;
        Fri, 12 Jul 2019 12:42:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 12 Jul 2019 12:42:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [37.29.175.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A03CD4265A32;
        Fri, 12 Jul 2019 12:42:26 +0200 (CEST)
Date:   Fri, 12 Jul 2019 12:42:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src/ct: provide fixed data lengh sizes for ip/ip6
 keys
Message-ID: <20190712104224.fodcfgcivxst46jj@salvia>
References: <20190712103503.22825-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712103503.22825-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 12, 2019 at 12:35:03PM +0200, Florian Westphal wrote:
> nft can load but not list this:
> 
> table inet filter {
>  chain input {
>   ct original ip daddr {1.2.3.4} accept
>  }
> }
> 
> Problem is that the ct template length is 0, so we believe the right hand
> side is a concatenation because left->len < set->key->len is true.
> nft then calls abort() during concatenation parsing.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1222
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Please, add new entry to tests/py before pushing this out.
