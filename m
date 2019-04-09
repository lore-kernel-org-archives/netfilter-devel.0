Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BBAC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088682084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfDINCL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:02:11 -0400
Received: from mail.us.es ([193.147.175.20]:58620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfDINCL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:02:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30D6E9356D
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 15:02:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C0C9DA718
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 15:02:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1AD6ADA710; Tue,  9 Apr 2019 15:02:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E85CDA703;
        Tue,  9 Apr 2019 15:02:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 15:02:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0D9AB4265A31;
        Tue,  9 Apr 2019 15:02:06 +0200 (CEST)
Date:   Tue, 9 Apr 2019 15:02:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, arturo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nft] evaluate: disallow anonymous set with empty elements
Message-ID: <20190409130205.rp6a6xmwnxnq62oa@salvia>
References: <20190409105936.23422-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409105936.23422-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 12:59:36PM +0200, Pablo Neira Ayuso wrote:
> Restrict this, the brackets have explicit semantics since they tell the
> kernel to represent this value as a set, which is too costly. Set for
> one single element are overkill.
> 
>  # nft add rule x y ct state { established } counter
>  Error: anonymous set with single element makes no sense, remove brackets wrapping this value
>  add rule x y ct state { established } counter
>                        ^^^^^^^^^^^^^^^
> 
> Instead, the preferred way to express this is:
> 
>  # nft add rule x y ct state established counter
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I know this may break stuff outthere, but probably it's still early to
> fix this. If we keep allowing this and transparently turn this into a
> value, people will likely never understand the bracket semantics.
> Brackets are not just syntaxic sugar.

This patch is broken, will send v2, and I need to adapt tests after
this change. It's a bit of work but it is doable.

We also need a way not to fail on "define" (definition) that allows a
set with one single element, since this can be used from literal sets.
Will require a bit more code.
