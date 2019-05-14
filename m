Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3148C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 22:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A47F20645
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 22:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfENWyX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 18:54:23 -0400
Received: from mail.us.es ([193.147.175.20]:49016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENWyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 18:54:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB79CF2785
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 00:54:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C41F5DA701
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 00:54:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B9DB5DA705; Wed, 15 May 2019 00:54:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCAADDA701;
        Wed, 15 May 2019 00:54:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 May 2019 00:54:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A8C5F4265A31;
        Wed, 15 May 2019 00:54:18 +0200 (CEST)
Date:   Wed, 15 May 2019 00:54:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 nft] jump: Introduce chain_expr in jump and goto
 statements
Message-ID: <20190514225418.qi7nm6htm3v4fner@salvia>
References: <20190514211340.913-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514211340.913-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 14, 2019 at 11:13:39PM +0200, Fernando Fernandez Mancera wrote:
[...]
> diff --git a/src/expression.c b/src/expression.c
> index eece12e..55a4ad7 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -207,17 +207,18 @@ static bool verdict_expr_cmp(const struct expr *e1, const struct expr *e2)
>  
>  	if ((e1->verdict == NFT_JUMP ||
>  	     e1->verdict == NFT_GOTO) &&
> -	    strcmp(e1->chain, e2->chain))
> -		return false;
> +	     (expr_basetype(e1) == expr_basetype(e2) &&
> +	     !mpz_cmp(e1->value, e2->value)))

Maybe replace these two new lines above by:

              expr_cmp(e1->chain, e2->chain)

> +		return true;
>  
> -	return true;
> +	return false;
>  }
>  
>  static void verdict_expr_clone(struct expr *new, const struct expr *expr)
>  {
>  	new->verdict = expr->verdict;
>  	if (expr->chain != NULL)
> -		new->chain = xstrdup(expr->chain);
> +		mpz_init_set(new->chain->value, expr->chain->value);
>  }
>  
>  static void verdict_expr_destroy(struct expr *expr)

Memleak here in verdict_expr_destroy(), you need to call:

        expr_free(expr->chain);

instead of:

        xfree(expr->chain)

Please, run valgrind with --leak-check=full to make sure there are no
leaks either from adding a new rule nor when listing the ruleset.

Thanks!
