Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B3CC71153
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 16:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjH1QEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 12:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjH1QEd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 12:04:33 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F01AE
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 09:04:23 -0700 (PDT)
Received: from [78.30.34.192] (port=37992 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qaeiw-00AWC3-WF; Mon, 28 Aug 2023 18:04:21 +0200
Date:   Mon, 28 Aug 2023 18:04:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/8] src: rework SNPRINTF_BUFFER_SIZE() and avoid
 "-Wunused-but-set-variable"
Message-ID: <ZOzFgtwJI6AasAYZ@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
 <20230828144441.3303222-6-thaller@redhat.com>
 <ZOy5nTEQJvu7zdrx@calendula>
 <aa481d83b0320078a17bebf215378992a4f7cb21.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa481d83b0320078a17bebf215378992a4f7cb21.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 05:49:53PM +0200, Thomas Haller wrote:
> On Mon, 2023-08-28 at 17:13 +0200, Pablo Neira Ayuso wrote:
[...]
> > > diff --git a/include/utils.h b/include/utils.h
> > > index cee1e5c1e8ae..873147fb54ec 100644
> > > --- a/include/utils.h
> > > +++ b/include/utils.h
> > > @@ -72,15 +72,29 @@
> > >  #define max(_x, _y) ({                         \
> > >         _x > _y ? _x : _y; })
> > >  
> > > -#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)   \
> > > -       if (ret < 0)                                    \
> > > -               abort();                                \
> > > -       offset += ret;                                  \
> > > -       assert(ret < len);                              \
> > > -       if (ret > len)                                  \
> > > -               ret = len;                              \
> > > -       size += ret;                                    \
> > > -       len -= ret;
> > > +#define SNPRINTF_BUFFER_SIZE(ret, len, offset)                 \
> > > +       do { \
> > > +               const int _ret = (ret);                         \
> > > +               size_t *const _len = (len);                     \
> > > +               size_t *const _offset = (offset);               \
> > > +               size_t _ret2;                                   \
> > > +                                                               \
> > > +               assert(_ret >= 0);                              \
> > > +                                                               \
> > > +               if ((size_t) _ret >= *_len) {                   \
> > > +                       /* Fail an assertion on truncation.
> > > +                        *
> > > +                        * Anyway, we would set "len" to zero and
> > > "offset" one
> > > +                        * after the buffer size (past the
> > > terminating NUL
> > > +                        * byte). */                            \
> > > +                       assert((size_t) _ret < *_len);          \
> > > +                       _ret2 = *_len;                          \
> > > +               } else                                          \
> > > +                       _ret2 = (size_t) _ret;                  \
> > > +                                                               \
> > > +               *_offset += _ret2;                              \
> > > +               *_len -= _ret2;                                 \
> > > +       } while (0)
> > 
> > This macro is something I made myself, which I am particularly not
> > proud of it, but it getting slightly more complicated.
> 
> IMO it just got simpler. E.g. it is now function-like; you can easier
> see which arguments are modified (we take a pointer to them); one
> argument got dropped.
>
> The remaining relevant parts (assertions and truncation check aside) is
> literally
> 
>    offset += ret;
>    len -= ret;
> 
> > 
> > Probably it time to turn this into a real function?
> 
> as it now behaves function-like, it can be easily converted to an
> inline function. Only difference is that upon assertion failure, we no
> longer see the location of the caller. It does not seem an improvement.

No need for inline in this case, this is not performance critical, it
will increase size of binary, better let the compiler decide. What is
left to turn this into a real function? It looks like a candidate for
the new nftutils.c file to me.

> > >  #define MSEC_PER_SEC   1000L
> > >  
> > > diff --git a/src/evaluate.c b/src/evaluate.c
> > > index 1ae2ef0de10c..f8cd7b7afda3 100644
> > > --- a/src/evaluate.c
> > > +++ b/src/evaluate.c
> > > @@ -4129,14 +4129,16 @@ static int stmt_evaluate_queue(struct
> > > eval_ctx *ctx, struct stmt *stmt)
> > >  static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct
> > > stmt *stmt)
> > >  {
> > >         char prefix[NF_LOG_PREFIXLEN] = {}, tmp[NF_LOG_PREFIXLEN] =
> > > {};
> > > -       int len = sizeof(prefix), offset = 0, ret;
> > > +       size_t len = sizeof(prefix);
> > > +       size_t offset = 0;
> > >         struct expr *expr;
> > > -       size_t size = 0;
> > >  
> > >         if (stmt->log.prefix->etype != EXPR_LIST)
> > >                 return 0;
> > >  
> > >         list_for_each_entry(expr, &stmt->log.prefix->expressions,
> > > list) {
> > > +               int ret;
> > > +
> > >                 switch (expr->etype) {
> > >                 case EXPR_VALUE:
> > >                         expr_to_string(expr, tmp);
> > > @@ -4150,12 +4152,9 @@ static int stmt_evaluate_log_prefix(struct
> > > eval_ctx *ctx, struct stmt *stmt)
> > >                         BUG("unknown expression type %s\n",
> > > expr_name(expr));
> > >                         break;
> > >                 }
> > > -               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> > > +               SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
> > >         }
> > >  
> > > -       if (len == NF_LOG_PREFIXLEN)
> > > -               return stmt_error(ctx, stmt, "log prefix is too
> > > long");
> > 
> > No error anymore?
> > 
> > Not directly related, but are you sure tests we have are sufficient
> > to
> > cover for all these updates 
> 
> No. I am not aware of test coverage.

There is:

        tests/py

which are unitary tests, there is a README file, it tests control
plane only: it dump the output from the kernel to test listing path.
They also cover json support.

        tests/shell

are tests coverage in the form of shell scripts, some validates that
the output is correct via dump file, some others do not. They are more
flexible that tests/py.

There are also selftests in the netfilter folders, see:

        tools/testing/selftests/netfilter/

For libnftnl, there is a number of library API tests.

This is what we have by now.

> SNPRINTF_BUFFER_SIZE() rejects truncation of the string by asserting
> against it. That behavior is part of the API of that function. Error
> checking after an assert seems unnecessary.
> 
> The check "if (len == NF_LOG_PREFIXLEN)" seems wrong anyway. After
> truncation, "len" would be zero. The code previously checked whether
> nothing was appended, but the error string didn't match that situation.
> 
> Maybe SNPRINTF_BUFFER_SIZE() should not assert against truncation?

IIRC, the goal for this function was to handle snprintf() and all its
corner cases. If there is no need for it or a better way to do this,
this is welcome.
