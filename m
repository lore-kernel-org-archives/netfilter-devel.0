Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF310C48BE3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D5D2089E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFUQG6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 12:06:58 -0400
Received: from mail.us.es ([193.147.175.20]:60294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfFUQG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 12:06:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 578AEEDB0F
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:06:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 476BFDA70D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 18:06:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3CD20DA70C; Fri, 21 Jun 2019 18:06:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 458F5DA704;
        Fri, 21 Jun 2019 18:06:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 18:06:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 226A94265A2F;
        Fri, 21 Jun 2019 18:06:54 +0200 (CEST)
Date:   Fri, 21 Jun 2019 18:06:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl v2] src: libnftnl: add support for matching IPv4
 options
Message-ID: <20190621160653.ektgcsz2oo47etsh@salvia>
References: <20190620115429.3678-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620115429.3678-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 07:54:29AM -0400, Stephen Suryaputra wrote:
[...]
> diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
> index bef453e..e5f714b 100644
> --- a/src/expr/exthdr.c
> +++ b/src/expr/exthdr.c
> @@ -200,6 +200,9 @@ static const char *op2str(uint8_t op)
>  	case NFT_EXTHDR_OP_TCPOPT:
>  		return " tcpopt";
>  	case NFT_EXTHDR_OP_IPV6:
> +		return " ipv6";
> +	case NFT_EXTHDR_OP_IPV4:
> +		return " ipv4";
>  	default:
>  		return "";
>  	}

Would you mind to install libnftnl with this patch on top and run:

nftables/tests/py/# python nft-tests.py

to check if this breaks testcases, if so a patch to update tests in
nftables would be great too.

Thanks!

> @@ -209,6 +212,8 @@ static inline int str2exthdr_op(const char* str)
>  {
>  	if (!strcmp(str, "tcpopt"))
>  		return NFT_EXTHDR_OP_TCPOPT;
> +	if (!strcmp(str, "ipv4"))
> +		return NFT_EXTHDR_OP_IPV4;
>  
>  	/* if str == "ipv6" or anything else */
>  	return NFT_EXTHDR_OP_IPV6;
> -- 
> 2.17.1
> 
