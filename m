Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E07C7EE24
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 16:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378100AbjHRQLC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 12:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378416AbjHRQKb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 12:10:31 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DDBE42
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 09:10:28 -0700 (PDT)
Received: from [78.30.34.192] (port=33192 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qX23L-001Rym-QQ; Fri, 18 Aug 2023 18:10:26 +0200
Date:   Fri, 18 Aug 2023 18:10:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v2] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Message-ID: <ZN+X76/KObT2EOrg@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
 <20230818091926.526246-1-thaller@redhat.com>
 <ZN9AnetYNCRBODhb@calendula>
 <5541fc793b4346e2f00eaf3e7f18c754053d8d00.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5541fc793b4346e2f00eaf3e7f18c754053d8d00.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 18, 2023 at 04:14:01PM +0200, Thomas Haller wrote:
> Hi Pablo,
> 
> On Fri, 2023-08-18 at 11:57 +0200, Pablo Neira Ayuso wrote:
> > 
> > > -       struct protoent *p;
> > > -
> > >         if (!nft_output_numeric_proto(octx)) {
> > > -               p = getprotobynumber(mpz_get_uint8(expr->value));
> > > -               if (p != NULL) {
> > > -                       nft_print(octx, "%s", p->p_name);
> > > +               char name[1024];
> > 
> > Is there any definition that could be used instead of 1024. Same
> > comment for all other hardcoded buffers. Or maybe add a definition
> > for
> > this?
> 
> Added defines instead. See v3.
> 
> [...]
> 
> > >  #include <nftables.h>
> > >  #include <utils.h>
> > > @@ -105,3 +106,90 @@ int round_pow_2(unsigned int n)
> > >  {
> > >         return 1UL << fls(n - 1);
> > >  }
> > > +
> > 
> > Could you move this new code to a new file instead of utils.c? We are
> > slowing moving towards GPLv2 or any later for new code. Probably
> > netdb.c or pick a better name that you like.
> 
> This request leaves me with a lot of choices. I made them, but I guess
> you will have something to say about it. See v3.
> 
> > 
> > > +bool nft_getprotobynumber(int proto, char *out_name, size_t
> > > name_len)
> > > +{
> > > +       const struct protoent *result;
> > > +
> > > +#if HAVE_DECL_GETPROTOBYNUMBER_R
> > > +       struct protoent result_buf;
> > > +       char buf[2048];
> > > +       int r;
> > > +
> > > +       r = getprotobynumber_r(proto,
> > > +                              &result_buf,
> > > +                              buf,
> > > +                              sizeof(buf),
> > > +                              (struct protoent **) &result);
> > > +       if (r != 0 || result != &result_buf)
> > > +               result = NULL;
> > > +#else
> > > +       result = getprotobynumber(proto);
> > > +#endif
> > 
> > I'd suggest wrap this code with #ifdef's in a helper function.
> 
> I don't understand. nft_getprotobynumber() *is* that helper function to
> wrap the #if. This point is not addressed by v3 (??).

I mean, something like a smaller function:

static struct __nft_getprotobynumber(...)

that is wraps this code above and it returns const struct protoent.
This helper function is called from nft_getprotobynumber().

But it is fine as it is, this is just a bit of bike shedding.
