Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70E6C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D43218A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbfGWTSk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:18:40 -0400
Received: from mail.us.es ([193.147.175.20]:36126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbfGWTSk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 15:18:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66B94F2620
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:18:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56740CE158
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:18:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C129D1929; Tue, 23 Jul 2019 21:18:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B495DA704;
        Tue, 23 Jul 2019 21:18:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 21:18:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A3F4B4265A31;
        Tue, 23 Jul 2019 21:18:34 +0200 (CEST)
Date:   Tue, 23 Jul 2019 21:18:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190723191832.yz53ewe7smtujsmf@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721001406.23785-4-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> This makes nft behave like 0.9.0 -- the ruleset
> 
> flush ruleset
> table inet filter {
> }
> table inet filter {
>       chain test {
>         counter
>     }
> }
> 
> loads again without generating an error message.
> I've added a test case for this, without this it will create an error,
> and with a checkout of the 'fixes' tag we get crash.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351

This one should fix this bugzilla:

http://git.netfilter.org/nftables/commit/?id=3ab02db5f836ae0cf9fe7fba616d7eb52139d537

more comments below.

[...]
> diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
> index 05edc9c7c33e..fb4b0e24c790 100755
> --- a/tests/shell/testcases/cache/0003_cache_update_0
> +++ b/tests/shell/testcases/cache/0003_cache_update_0
> @@ -48,3 +48,15 @@ $NFT -f - >/dev/null <<EOF
>  add rule ip t4 c meta l4proto igmp accept
>  add rule ip t4 c index 2 drop
>  EOF
> +
> +# Trigger a crash or rule restore error with nft 0.9.1
> +$NFT -f - >/dev/null <<EOF
> +flush ruleset
> +table inet testfilter {
> +}
> +table inet testfilter {
> +      chain test {
> +        counter
> +    }
> +}
> +EOF

I have applied this test as an separated patch, thanks Florian.
