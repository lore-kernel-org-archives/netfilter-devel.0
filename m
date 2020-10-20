Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B74C4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEF52222D
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408617AbgJTPRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 11:17:31 -0400
Received: from correo.us.es ([193.147.175.20]:49238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731709AbgJTPRb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 11:17:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A06A21761B0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:17:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94066FC59B
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:17:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 89472FB37C; Tue, 20 Oct 2020 17:17:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FF08F7323;
        Tue, 20 Oct 2020 17:17:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:17:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 512F34301DE0;
        Tue, 20 Oct 2020 17:17:27 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:17:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ye Bin <yebin10@huawei.com>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: Fix inconsistent of format
 with argument type in nf_nat_sip.
Message-ID: <20201020151726.GA19756@salvia>
References: <20201009070335.63812-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201009070335.63812-1-yebin10@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 09, 2020 at 03:03:35PM +0800, Ye Bin wrote:
> Fix follow warning:
> [net/netfilter/nf_nat_sip.c:469]: (warning) %u in format string (no. 1)
> requires 'unsigned int' but the argument type is 'int'.

Yes, but mangle_packet() takes unsigned int as buflen.

This needs a bit wider look that, I'm afraid, a robot cannot afford.

Thanks for submitting your patch in any case.

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  net/netfilter/nf_nat_sip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
> index f0a735e86851..39754fb3a298 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -466,7 +466,7 @@ static int mangle_content_len(struct sk_buff *skb, unsigned int protoff,
>  			      &matchoff, &matchlen) <= 0)
>  		return 0;
>  
> -	buflen = sprintf(buffer, "%u", c_len);
> +	buflen = sprintf(buffer, "%d", c_len);
>  	return mangle_packet(skb, protoff, dataoff, dptr, datalen,
>  			     matchoff, matchlen, buffer, buflen);
>  }
> -- 
> 2.16.2.dirty
> 
