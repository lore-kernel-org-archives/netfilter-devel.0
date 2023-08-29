Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877A7C6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 19:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjH2TQG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 15:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbjH2TPo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 15:15:44 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBA810E6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:15:09 -0700 (PDT)
Received: from [78.30.34.192] (port=55728 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qb4Az-00FzRI-Rr; Tue, 29 Aug 2023 21:15:00 +0200
Date:   Tue, 29 Aug 2023 21:14:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/5] datatype: check against negative "type" argument
 in datatype_lookup()
Message-ID: <ZO5DsA4eCnYkEWxC@calendula>
References: <20230829185509.374614-1-thaller@redhat.com>
 <20230829185509.374614-6-thaller@redhat.com>
 <ZO5Cnmck5tKCvVFE@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZO5Cnmck5tKCvVFE@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 09:10:26PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 08:54:11PM +0200, Thomas Haller wrote:
> > An enum can be either signed or unsigned (implementation defined).
> > 
> > datatype_lookup() checks for invalid type arguments. Also check, whether
> > the argument is not negative (which, depending on the compiler it may
> > never be).
> > 
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> >  src/datatype.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/src/datatype.c b/src/datatype.c
> > index ba1192c83595..91735ff8b360 100644
> > --- a/src/datatype.c
> > +++ b/src/datatype.c
> > @@ -87,7 +87,7 @@ const struct datatype *datatype_lookup(enum datatypes type)
> >  {
> >  	BUILD_BUG_ON(TYPE_MAX & ~TYPE_MASK);
> >  
> > -	if (type > TYPE_MAX)
> > +	if ((uintmax_t) type > TYPE_MAX)
> 
>             uint32_t ?

Another question: What warning does clang print on this one?
Description does not specify.

> >  		return NULL;
> >  	return datatypes[type];
> >  }
> > -- 
> > 2.41.0
> > 
