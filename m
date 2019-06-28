Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4751DC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 09:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284E320644
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 09:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfF1JHx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:07:53 -0400
Received: from mail.us.es ([193.147.175.20]:40888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF1JHx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 05:07:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E5EDC3302
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 11:07:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D17F1021A6
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 11:07:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 72C6B1021A4; Fri, 28 Jun 2019 11:07:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E95EDA4D1;
        Fri, 28 Jun 2019 11:07:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 11:07:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4DAD14265A2F;
        Fri, 28 Jun 2019 11:07:49 +0200 (CEST)
Date:   Fri, 28 Jun 2019 11:07:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nat: Update obsolete comment on
 get_unique_tuple()
Message-ID: <20190628090748.e42ymhe3huvuduhj@salvia>
References: <20190627212307.GB4897@jong.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627212307.GB4897@jong.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 28, 2019 at 12:23:08AM +0300, Yonatan Goldschmidt wrote:
> Commit c7232c9979cba ("netfilter: add protocol independent NAT core")
> added nf_nat_core.c based on ipv4/netfilter/nf_nat_core.c,
> with this comment copied.
> 
> Referred function doesn't exist anymore, and anyway since day one
> of this file it should have referred the generic __nf_conntrack_confirm(),
> added in 9fb9cbb1082d6.
> 
> Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
> ---
>  net/netfilter/nf_nat_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 9ab410455992..3f6023ed4966 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
>   * and NF_INET_LOCAL_OUT, we change the destination to map into the
>   * range. It might not be possible to get a unique tuple, but we try.
>   * At worst (or if we race), we will end up with a final duplicate in
> - * __ip_conntrack_confirm and drop the packet. */
> + * __nf_conntrack_confirm and drop the packet. */

I dislike this oneliners to update comments, I tend to think it's too
much overhead a patch just to update something obvious to the reader.

However, I also understand you may want to fix this while passing by
here.

So my sugggestion is that you run:

        git grep ip_conntrack

in the tree, searching for comments and documentation that can be
updated, eg.

net/netfilter/nf_conntrack_proto_icmp.c:        /* See ip_conntrack_proto_tcp.c */

Please, only update comments / documentation in your patch.

The ip_conntrack_ prefix is legacy, that it was used by the time there
was only support for IPv4 in the connection tracking system.

Thanks.
