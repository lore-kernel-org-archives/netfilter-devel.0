Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C949C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 17:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4991F2073B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 17:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWxfHzIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgEZRRf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 13:17:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728810AbgEZRRf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 13:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iv69uIN44VU4tt54qFmmEVHQtmVN1ITKXJ084ntigdk=;
        b=NWxfHzIfZpUXb0B5WMuf+5PRQHm+sh1IWYcGauknAN+cD89LxzEFbqnuqoM9n/4yBjnj9/
        2F0ORavQ3WHhwFdotq46xxL9TCVL7RH3rxcRSECKzOclsBQGUwxnvYHqjqGaYpF/vr/98C
        sgr0as5Fu3MxpkQNBk7G0vG2F2caVjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-S7nLAcFkO2aqTPuLWZeWbw-1; Tue, 26 May 2020 13:17:31 -0400
X-MC-Unique: S7nLAcFkO2aqTPuLWZeWbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65300835B42;
        Tue, 26 May 2020 17:17:30 +0000 (UTC)
Received: from localhost (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E7F719D61;
        Tue, 26 May 2020 17:17:29 +0000 (UTC)
Date:   Tue, 26 May 2020 19:17:25 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: Perform set evaluation on implicitly
 declared (anonymous) sets
Message-ID: <20200526191725.74128eac@redhat.com>
In-Reply-To: <20200526165416.GA16562@salvia>
References: <cover.1590324033.git.sbrivio@redhat.com>
        <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
        <20200526165416.GA16562@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 26 May 2020 18:54:16 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sun, May 24, 2020 at 03:00:26PM +0200, Stefano Brivio wrote:
> > If a set is implicitly declared, set_evaluate() is not called as a
> > result of cmd_evaluate_add(), because we're adding in fact something
> > else (e.g. a rule). Expression-wise, evaluation still happens as the
> > implicit set expression is eventually found in the tree and handled
> > by expr_evaluate_set(), but context-wise evaluation (set_evaluate())
> > is skipped, and this might be relevant instead.
> > 
> > This is visible in the reported case of an anonymous set including
> > concatenated ranges:
> > 
> >   # nft add rule t c ip saddr . tcp dport { 192.0.2.1 . 20-30 } accept
> >   BUG: invalid range expression type concat
> >   nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
> >   Aborted
> > 
> > because we reach do_add_set() without properly evaluated flags and
> > set description, and eventually end up in expr_to_intervals(), which
> > can't handle that expression.
> > 
> > Explicitly call set_evaluate() as we add anonymous sets into the
> > context, and instruct the same function to skip expression-wise set
> > evaluation if the set is anonymous, as that happens later anyway as
> > part of the general tree evaluation.
> > 
> > Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Reported-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  src/evaluate.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 506f2c6a257e..ee019bc98480 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -76,6 +76,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
> >  	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
> >  }
> >  
> > +static int set_evaluate(struct eval_ctx *ctx, struct set *set);
> >  static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
> >  					     const char *name,
> >  					     struct expr *key,
> > @@ -107,6 +108,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
> >  		list_add_tail(&cmd->list, &ctx->cmd->list);
> >  	}
> >  
> > +	set_evaluate(ctx, set);  
> 
> Hm, set_evaluate() populates the cache with the anonymous set in this
> case, see set_lookup() + sed_add_hash().

While checking what parts of set_evaluate() we should skip for anonymous
sets, I thought it made sense to keep that, simply because I didn't see
any value in making that a special case. Is the __set* stuff polluting?
Any other bad consequence I missed? Or you would skip that just because
it's useless?

-- 
Stefano

