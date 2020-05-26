Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356DBC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 16:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C8920776
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 16:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgEZQyV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 12:54:21 -0400
Received: from correo.us.es ([193.147.175.20]:46492 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgEZQyV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 12:54:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 80135EE48E
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 18:54:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 719E9DA707
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 18:54:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 70E81DA711; Tue, 26 May 2020 18:54:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 587BDDA707;
        Tue, 26 May 2020 18:54:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 May 2020 18:54:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3990E42EF42A;
        Tue, 26 May 2020 18:54:17 +0200 (CEST)
Date:   Tue, 26 May 2020 18:54:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: Perform set evaluation on implicitly
 declared (anonymous) sets
Message-ID: <20200526165416.GA16562@salvia>
References: <cover.1590324033.git.sbrivio@redhat.com>
 <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 24, 2020 at 03:00:26PM +0200, Stefano Brivio wrote:
> If a set is implicitly declared, set_evaluate() is not called as a
> result of cmd_evaluate_add(), because we're adding in fact something
> else (e.g. a rule). Expression-wise, evaluation still happens as the
> implicit set expression is eventually found in the tree and handled
> by expr_evaluate_set(), but context-wise evaluation (set_evaluate())
> is skipped, and this might be relevant instead.
> 
> This is visible in the reported case of an anonymous set including
> concatenated ranges:
> 
>   # nft add rule t c ip saddr . tcp dport { 192.0.2.1 . 20-30 } accept
>   BUG: invalid range expression type concat
>   nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
>   Aborted
> 
> because we reach do_add_set() without properly evaluated flags and
> set description, and eventually end up in expr_to_intervals(), which
> can't handle that expression.
> 
> Explicitly call set_evaluate() as we add anonymous sets into the
> context, and instruct the same function to skip expression-wise set
> evaluation if the set is anonymous, as that happens later anyway as
> part of the general tree evaluation.
> 
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  src/evaluate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 506f2c6a257e..ee019bc98480 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -76,6 +76,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
>  	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
>  }
>  
> +static int set_evaluate(struct eval_ctx *ctx, struct set *set);
>  static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
>  					     const char *name,
>  					     struct expr *key,
> @@ -107,6 +108,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
>  		list_add_tail(&cmd->list, &ctx->cmd->list);
>  	}
>  
> +	set_evaluate(ctx, set);

Hm, set_evaluate() populates the cache with the anonymous set in this
case, see set_lookup() + sed_add_hash().
