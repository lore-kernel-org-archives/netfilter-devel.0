Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A9FC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 18:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DE620776
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 18:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkX6RAJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgEZSBb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 14:01:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43814 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728643AbgEZSBb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 14:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590516090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOL9xgdC+SC48rHIM9oq7P40eSq2wZKNHpTFWTqNGSg=;
        b=WkX6RAJCRtiUJK4Jo1wyEvYn1QJDSSVPM+PWS7WRyaYiBTGkCvG3QpSB2JBtt/4GmZ43nE
        VTOZUpGWgOuh8p71Ti4/FbxNc1zhmlBpGz0P+K4lDpn6OCdYaOtny2r/fnOGP41JRaGrfK
        zSCkk6amqiGw2YB6pzHqjPcYycVhnLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-AhkGx7qsOw-RHT93hRXhKA-1; Tue, 26 May 2020 14:01:27 -0400
X-MC-Unique: AhkGx7qsOw-RHT93hRXhKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EDA119200C0;
        Tue, 26 May 2020 18:01:26 +0000 (UTC)
Received: from localhost (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D4FB10016DA;
        Tue, 26 May 2020 18:01:25 +0000 (UTC)
Date:   Tue, 26 May 2020 20:01:21 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: Perform set evaluation on implicitly
 declared (anonymous) sets
Message-ID: <20200526200121.0bef7de1@redhat.com>
In-Reply-To: <20200526173419.GA18499@salvia>
References: <cover.1590324033.git.sbrivio@redhat.com>
        <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
        <20200526165416.GA16562@salvia>
        <20200526191725.74128eac@redhat.com>
        <20200526173419.GA18499@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 26 May 2020 19:34:19 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, May 26, 2020 at 07:17:25PM +0200, Stefano Brivio wrote:
> > On Tue, 26 May 2020 18:54:16 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > On Sun, May 24, 2020 at 03:00:26PM +0200, Stefano Brivio wrote:  
> > > > If a set is implicitly declared, set_evaluate() is not called as a
> > > > result of cmd_evaluate_add(), because we're adding in fact something
> > > > else (e.g. a rule). Expression-wise, evaluation still happens as the
> > > > implicit set expression is eventually found in the tree and handled
> > > > by expr_evaluate_set(), but context-wise evaluation (set_evaluate())
> > > > is skipped, and this might be relevant instead.
> > > > 
> > > > This is visible in the reported case of an anonymous set including
> > > > concatenated ranges:
> > > > 
> > > >   # nft add rule t c ip saddr . tcp dport { 192.0.2.1 . 20-30 } accept
> > > >   BUG: invalid range expression type concat
> > > >   nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
> > > >   Aborted
> > > > 
> > > > because we reach do_add_set() without properly evaluated flags and
> > > > set description, and eventually end up in expr_to_intervals(), which
> > > > can't handle that expression.
> > > > 
> > > > Explicitly call set_evaluate() as we add anonymous sets into the
> > > > context, and instruct the same function to skip expression-wise set
> > > > evaluation if the set is anonymous, as that happens later anyway as
> > > > part of the general tree evaluation.
> > > > 
> > > > Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > Reported-by: Phil Sutter <phil@nwl.cc>
> > > > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > > > ---
> > > >  src/evaluate.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/src/evaluate.c b/src/evaluate.c
> > > > index 506f2c6a257e..ee019bc98480 100644
> > > > --- a/src/evaluate.c
> > > > +++ b/src/evaluate.c
> > > > @@ -76,6 +76,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
> > > >  	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
> > > >  }
> > > >  
> > > > +static int set_evaluate(struct eval_ctx *ctx, struct set *set);
> > > >  static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
> > > >  					     const char *name,
> > > >  					     struct expr *key,
> > > > @@ -107,6 +108,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
> > > >  		list_add_tail(&cmd->list, &ctx->cmd->list);
> > > >  	}
> > > >  
> > > > +	set_evaluate(ctx, set);    
> > > 
> > > Hm, set_evaluate() populates the cache with the anonymous set in this
> > > case, see set_lookup() + sed_add_hash().  
> > 
> > While checking what parts of set_evaluate() we should skip for anonymous
> > sets, I thought it made sense to keep that, simply because I didn't see
> > any value in making that a special case. Is the __set* stuff polluting?  
> 
> Yes, it's just adding a __set%d to the cache.
> 
> > Any other bad consequence I missed? Or you would skip that just because
> > it's useless?  
> 
> I did not find any command that triggers any problem right now. I just
> think we should not add an anonymous set to the cache.

Okay, I see.

> BTW, are not set->desc.field_len and set->key->field_len duplicated
> fields? Same thing with field_count.

Yes, they are, but:

> Probably it should be possible to simplify this by using
> set->key->field* instead? So set_evaluate() is not required to
> transfer the fields.

...even if we use those, we still need to call expr_evaluate_concat()
(with the same logic as implemented by set_evaluate()) to fill the
set->key fields in.

Conceptually, I think that set_evaluate() should apply just in the same
way no matter how sets are created, minus expression evaluation and
caching. Taking selecting bits out looks a bit fragile/inconsistent to
me. Maybe I'm biased by the fact it was relatively complicated for me
to narrow down this particular issue.

-- 
Stefano

