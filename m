Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661D5C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B4C21670
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfIDJ3i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:29:38 -0400
Received: from correo.us.es ([193.147.175.20]:56424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfIDJ3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 05:29:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A238DA718
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 11:29:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B0396D28E
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 11:29:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A558CE15C; Wed,  4 Sep 2019 11:29:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 897DBB7FF9;
        Wed,  4 Sep 2019 11:29:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 11:29:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 685214265A5A;
        Wed,  4 Sep 2019 11:29:31 +0200 (CEST)
Date:   Wed, 4 Sep 2019 11:29:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix possible null-pointer
 dereference in object update
Message-ID: <20190904092932.imuzrpd33khu57er@salvia>
References: <20190903213313.1080-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903213313.1080-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 03, 2019 at 11:33:13PM +0200, Fernando Fernandez Mancera wrote:
> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  net/netfilter/nf_tables_api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index cf767bc58e18..6893de9e1389 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6477,7 +6477,8 @@ static void nft_obj_commit_update(struct nft_trans *trans)
>  	obj = nft_trans_obj(trans);
>  	newobj = nft_trans_obj_newobj(trans);
>  
> -	obj->ops->update(obj, newobj);
> +	if (obj->ops->update)
> +		obj->ops->update(obj, newobj);

Please, check for obj->ops->update() from the preparation phase, ie.
from nf_tables_updobj().

If obj->ops->update is NULL, then return -EOPNOTSUPP.
