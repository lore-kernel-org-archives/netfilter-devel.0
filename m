Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21877C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8F6229EB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbfGWTT5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:19:57 -0400
Received: from mail.us.es ([193.147.175.20]:36326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfGWTT5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 15:19:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C65AF2629
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:19:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CF73D1929
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:19:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22BEFDA732; Tue, 23 Jul 2019 21:19:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33DB61FFC9;
        Tue, 23 Jul 2019 21:19:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 21:19:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D3DFE4265A31;
        Tue, 23 Jul 2019 21:19:52 +0200 (CEST)
Date:   Tue, 23 Jul 2019 21:19:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] src: erec: fall back to internal location if its
 null
Message-ID: <20190723191951.qtna27k56gqwfqdy@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721001406.23785-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 02:14:05AM +0200, Florian Westphal wrote:
> This should never happen (we should pass valid locations to the error
> reporting functions), but in case we screw up we will segfault during
> error reporting.
> 
> cat crash
> table inet filter {
> }
> table inet filter {
>       chain test {
>         counter
>     }
> }
> "nft -f crash" Now reports:
> internal:0:0-0: Error: No such file or directory
> 
> ... which is both bogus and useless, but better than crashing.

I'd suggest we add BUG() here, so we catch missing location
information via indesc == NULL. So we can fix the lack of it,
otherwise users will rely on internal, which is very limited.

Thanks.
