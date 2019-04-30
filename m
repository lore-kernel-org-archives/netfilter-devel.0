Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A82C04AA6
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 13:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DE521670
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 13:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COjeKP99"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfD3NDt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:03:49 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:32857 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfD3NDt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 09:03:49 -0400
Received: by mail-ot1-f65.google.com with SMTP id s11so7480411otp.0
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 06:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OguJTAmrYmpGwm/YehMrXnagMAv2liHSExT8Lmu9qYY=;
        b=COjeKP99cSP96WxlG2Wp7hARIWuIjDp/bO0UKCsAohWEiwD7oyaatN0e/9LLQXajDO
         4aazjGlbPV63N4UGDpYMxe22LSq9eECsEFg0hTpbrVzHj4vlMsMzAp9cg151yZ3P3DP+
         rq7e4CJiqycXjMDI2c8kvfvJ759sI6d6HL45LT3fE/4P4V+fTrowUbQe6zYVBncUn7m5
         OlwwF3ek+0QyF2ZNchrf0/W2gPpps/pPI5nvTSmR7MLwokadQj37AH+QhVzU9R4fBY/E
         JqZP3lFbqsRlddLc7T/T6lbu4pP9HnI+WWNjmowUqTANUXu3650CE+Ie9bE4/r38GbsS
         ZP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OguJTAmrYmpGwm/YehMrXnagMAv2liHSExT8Lmu9qYY=;
        b=aaY2XKnqNoAVnicm2LajfEzrM1b8qnNALn3ZKS8RTyXluaw53OBaBpfE0e893F9SRk
         bx0qNrDsx2ETGhYXo6NHtdOV40P8rp8V2ekFDMSzl0H0a2GK7nU+Bs/3TDPGUARH2etO
         0nlhL8INMRraW9Vi4mApzMgerVbrmfKya7Nak5FfOPUl9vc6u7p6yy72nJaOW9iHgv84
         o8mv3SzpCE2LPV9vOvABBQm5QWEXXimp0E4E2ZAGUlZ3b4QrI6iYGs7zLkd9vZkM6fol
         hmzNg27iiRlMDwwkfsbDurHckmx1JRNHWbX8TtI7XU4vehP2wlLkNiVUDBK2YdfrYgGV
         SbVw==
X-Gm-Message-State: APjAAAWb4Z+K+tFLrCk10NLt8iw3t6UCGMlicp/zaxFcqA+QoTSd0G0U
        /DwHclcOXfMw8eDtD4w3BW7I2wfmYVhibHcHWzLlUw==
X-Google-Smtp-Source: APXvYqyOI8KqV0kdulbIQfF17jftovDRyDstmPMML8oiN8jyHHeHESYRH0NyHCCXaqS0eFiybMubqyj3oUooPQ1v+qY=
X-Received: by 2002:a9d:5604:: with SMTP id e4mr24391528oti.336.1556629428830;
 Tue, 30 Apr 2019 06:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190429165614.1506-1-ap420073@gmail.com> <20190430115908.2heamxb6yenzh65s@salvia>
In-Reply-To: <20190430115908.2heamxb6yenzh65s@salvia>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 30 Apr 2019 22:03:37 +0900
Message-ID: <CAMArcTWJf3bXCeLaMAXiMsHSM7eZaqfZSzYKE5AvbzB8Xnoreg@mail.gmail.com>
Subject: Re: [PATCH nf v2 3/3] netfilter: nf_flow_table: do not use deleted
 CT's flow offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 30 Apr 2019 at 20:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Apr 30, 2019 at 01:56:14AM +0900, Taehee Yoo wrote:
> > flow offload of CT can be deleted by the masquerade module. then,
> > flow offload should be deleted too. but GC and data-path of flow offload
> > do not check CT's status. hence they will be removed only by the timeout.
> >
> > GC and data-path routine will check ct->status.
> > If IPS_DYING_BIT is set, GC will delete CT and data-path routine
> > do not use it.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >
> > v1 -> v2 : use IPS_DYING_BIT instead of ct->ct_general.use refcnt.
> >
> >  net/netfilter/nf_flow_table_core.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 7aabfd4b1e50..50d04a718b41 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -232,6 +232,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
> >  {
> >       struct flow_offload_tuple_rhash *tuplehash;
> >       struct flow_offload *flow;
> > +     struct flow_offload_entry *e;
> >       int dir;
> >
> >       tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
> > @@ -244,6 +245,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
> >       if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
> >               return NULL;
> >
> > +     e = container_of(flow, struct flow_offload_entry, flow);
> > +     if (unlikely(test_bit(IPS_DYING_BIT, &e->ct->status)))
>
> Please, send a new version of this patch that uses:
>
>         nf_ct_is_dying()
>
> Thanks.
>

Thank you for the review and I will send v3 patch for using nf_ct_is_dying()

Thank you again!

> > +             return NULL;
> > +
> >       return tuplehash;
> >  }
> >  EXPORT_SYMBOL_GPL(flow_offload_lookup);
> > @@ -290,9 +295,12 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
> >  static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
> >  {
> >       struct nf_flowtable *flow_table = data;
> > +     struct flow_offload_entry *e;
> >
> > +     e = container_of(flow, struct flow_offload_entry, flow);
> >       if (nf_flow_has_expired(flow) ||
> > -         (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
> > +         (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)) ||
> > +         (test_bit(IPS_DYING_BIT, &e->ct->status)))
> >               flow_offload_del(flow_table, flow);
> >  }
> >
> > --
> > 2.17.1
> >
