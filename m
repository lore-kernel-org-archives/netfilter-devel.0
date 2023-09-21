Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EAAE7D0AD
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 20:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjIUUdN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjIUUcy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 16:32:54 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DFC7960A
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:34:52 -0700 (PDT)
Received: from [78.30.34.192] (port=50182 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qjKWI-009mRI-2B; Thu, 21 Sep 2023 16:19:08 +0200
Date:   Thu, 21 Sep 2023 16:19:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 7/9] expression: cleanup expr_ops_by_type() and
 handle u32 input
Message-ID: <ZQxQ2bDCBBZGGfAR@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-8-thaller@redhat.com>
 <ZQs2Pmq6J5ZdXDQb@calendula>
 <47d61eebc85999dbd2f5b7a038b00723dea70cae.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47d61eebc85999dbd2f5b7a038b00723dea70cae.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 09:28:29PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-20 at 20:13 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 20, 2023 at 04:26:08PM +0200, Thomas Haller wrote:
> > > 
> > > -const struct expr_ops *expr_ops_by_type(enum expr_types value)
> > > +const struct expr_ops *expr_ops_by_type_u32(uint32_t value)
> > >  {
> > > -       /* value might come from unreliable source, such as "udata"
> > > -        * annotation of set keys.  Avoid BUG() assertion.
> > > -        */
> > > -       if (value == EXPR_INVALID || value > EXPR_MAX)
> > > +       if (value > (uint32_t) EXPR_MAX)
> > 
> > I think this still allows a third party to set EXPR_INVALID in the
> > netlink userdata attribute, right?
> > 
> > >                 return NULL;
> > > -
> > >         return __expr_ops_by_type(value);
> > >  }
> 
> Yes, it still allows that. It's handled by the following
> __expr_ops_by_type(), which returns NULL for invalid types (like
> EXPR_INVALID).

Oh indeed.

> The check "if (value > (uint32_t) EXPR_MAX)" is only here to ensure
> that nothing is lost while casting the uint32_t "value" to the enum
> expr_types.

Is this cast really required? This is to handle the hypothetical case
where EXPR_MAX ever gets a negative value?
