Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EEAC5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 09:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B4F42087E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 09:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbfKFJeM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 04:34:12 -0500
Received: from correo.us.es ([193.147.175.20]:59804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731785AbfKFJdw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 04:33:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49EB47FC4E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 10:33:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ABF1A7EC1
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 10:33:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2F525B8001; Wed,  6 Nov 2019 10:33:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C5FDB8014;
        Wed,  6 Nov 2019 10:33:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 10:33:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DB0C54251482;
        Wed,  6 Nov 2019 10:33:45 +0100 (CET)
Date:   Wed, 6 Nov 2019 10:33:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     fw@strlen.de, davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH v2] [netfilter]: Fix skb->csum calculation when netfilter
 manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Message-ID: <20191106093347.inrzhrlrle6g6naf@salvia>
References: <1572368351-3156-1-git-send-email-pchaudhary@linkedin.com>
 <1572368351-3156-2-git-send-email-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572368351-3156-2-git-send-email-pchaudhary@linkedin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Praveen,

On Tue, Oct 29, 2019 at 09:59:11AM -0700, Praveen Chaudhary wrote:
> No need to update skb->csum in function inet_proto_csum_replace16(),
> even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
> header checksum field and change in IPV6 header cancels each other
> for skb->csum calculation.

Two comestic issues with this patch:

* Patch subject is a bit long, could you rewrite it? Probably:

  net: Fix skb->csum update on inet_proto_csum_replace16()

And describe in the patch description that you trigger this from
netfilter IPv6 and NF_NAT_MANIP_SRC\DST.

* Regarding the comment on top of the function, could you make it fit
  into the 80-chars per column, it is shrinked to less than 70-chars per
  column for some reason. Probably you can just fully document this
  function while including this description, as it happens with other
  functions in this file (this last sentence is a suggestion, not a
  dealbreaker).

BTW, in your description you refer to < 3.16 though, and I I think the
problem manifests since ce25d66ad5f8d92, correct?

Thanks.

> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> Signed-off-by: Andy Stracner <astracner@linkedin.com>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> ---
> Changes in V2.
> 1.) Updating diff as per email discussion with Florian Westphal.
>     Since inet_proto_csum_replace16() does incorrect calculation
>     for skb->csum in all cases.
> 2.) Change in Commmit logs.
> ---
> ---
>  net/core/utils.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/utils.c b/net/core/utils.c
> index 6b6e51d..cec9924 100644
> --- a/net/core/utils.c
> +++ b/net/core/utils.c
> @@ -438,6 +438,12 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(inet_proto_csum_replace4);
>  
> +/**
> + * No need to update skb->csum in this function, even if
> + * skb->ip_summed == CHECKSUM_COMPLETE, because change in
> + * L4 header checksum field and change in IPV6 header
> + * cancels each other for skb->csum calculation.
> + */
>  void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>  			       const __be32 *from, const __be32 *to,
>  			       bool pseudohdr)
> @@ -449,9 +455,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>  	if (skb->ip_summed != CHECKSUM_PARTIAL) {
>  		*sum = csum_fold(csum_partial(diff, sizeof(diff),
>  				 ~csum_unfold(*sum)));
> -		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
> -			skb->csum = ~csum_partial(diff, sizeof(diff),
> -						  ~skb->csum);
>  	} else if (pseudohdr)
>  		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
>  				  csum_unfold(*sum)));
> -- 
> 2.7.4
> 
