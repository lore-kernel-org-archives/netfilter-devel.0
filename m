Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29B2C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF7E207CD
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgH0RzW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:55:22 -0400
Received: from correo.us.es ([193.147.175.20]:50554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgH0RzU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 13:55:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D76218CE7A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:55:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2E21DA730
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:55:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8824DA722; Thu, 27 Aug 2020 19:55:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94537DA704;
        Thu, 27 Aug 2020 19:55:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Aug 2020 19:55:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 763B741E4801;
        Thu, 27 Aug 2020 19:55:17 +0200 (CEST)
Date:   Thu, 27 Aug 2020 19:55:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Quentin Armitage <quentin@armitage.org.uk>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nftables: fix documentation for dup statement
Message-ID: <20200827175517.GA24746@salvia>
References: <f9bc9e191b03728fe233ca7a75fdc40ede0fde8e.camel@armitage.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9bc9e191b03728fe233ca7a75fdc40ede0fde8e.camel@armitage.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Quentin,

Thanks for your patch:

On Thu, Aug 27, 2020 at 04:42:00PM +0100, Quentin Armitage wrote:
> 
> The dup statement requires an address, and the device is optional,
> not the other way round.

table netdev x {
        chain y {
                type filter hook ingress device "eth0" priority filter; policy accept;
                ip protocol udp dup to "eth1"
        }
}

I think probably it should be good to clarify that:

- dup to 'device'
- fwd to 'device'

only work from the netdev family.

Thanks.

> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> ---
>  doc/statements.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doc/statements.txt b/doc/statements.txt
> index 9155f286..835db087 100644
> --- a/doc/statements.txt
> +++ b/doc/statements.txt
> @@ -648,7 +648,7 @@ The dup statement is used to duplicate a packet and send the
> copy to a different
>  destination.
>  
>  [verse]
> -*dup to* 'device'
> +*dup to* 'address'
>  *dup to* 'address' *device* 'device'
>  
>  .Dup statement values
> -- 
> 2.25.4
> 
> 
