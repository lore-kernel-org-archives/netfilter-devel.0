Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DED9C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AAD2080A
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfFQWZM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:25:12 -0400
Received: from mail.us.es ([193.147.175.20]:59726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFQWZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:25:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 003A5BEBA3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:25:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E51D8DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:25:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DAAD0DA703; Tue, 18 Jun 2019 00:25:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDD22DA703;
        Tue, 18 Jun 2019 00:25:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:25:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AC2F54265A2F;
        Tue, 18 Jun 2019 00:25:07 +0200 (CEST)
Date:   Tue, 18 Jun 2019 00:25:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Igor Ryzhov <iryzhov@nfware.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Message-ID: <20190617222507.tzizsd6dfxm6zozs@salvia>
References: <20190605093240.23212-1-iryzhov@nfware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605093240.23212-1-iryzhov@nfware.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 05, 2019 at 12:32:40PM +0300, Igor Ryzhov wrote:
> ct_sip_next_header and ct_sip_get_header return an absolute
> value of matchoff, not a shift from current dataoff.
> So dataoff should be assigned matchoff, not incremented by it.

Could we get a more detailed description of this bug? A description of
the simplified scenario / situation that help you found it would help
here.

Thanks.

> Signed-off-by: Igor Ryzhov <iryzhov@nfware.com>
> ---
>  net/netfilter/nf_conntrack_sip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index c30c883c370b..966c5948f926 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -480,7 +480,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
>  				return ret;
>  			if (ret == 0)
>  				break;
> -			dataoff += *matchoff;
> +			dataoff = *matchoff;
>  		}
>  		*in_header = 0;
>  	}
> @@ -492,7 +492,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
>  			break;
>  		if (ret == 0)
>  			return ret;
> -		dataoff += *matchoff;
> +		dataoff = *matchoff;
>  	}
>  
>  	if (in_header)
> -- 
> 2.21.0
> 
