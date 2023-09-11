Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633C9CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 02:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbjILCrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbjILCrX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 22:47:23 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76580412C5
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 19:12:34 -0700 (PDT)
Received: from [31.221.198.239] (port=5760 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qfoHH-009c5v-Ck; Mon, 11 Sep 2023 23:17:07 +0200
Date:   Mon, 11 Sep 2023 23:17:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] nlmsg, attr: fix false positives when validating
 buffer sizes
Message-ID: <ZP+DzR3lgFd9wymG@calendula>
References: <20230910203018.2782009-1-jeremy@azazel.net>
 <ZP9oyPItYTM2EVuw@calendula>
 <ZP9pVfzfv7SYYUM9@calendula>
 <20230911203026.GA772964@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911203026.GA772964@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 11, 2023 at 09:30:26PM +0100, Jeremy Sowden wrote:
> On 2023-09-11, at 21:24:05 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 11, 2023 at 09:21:50PM +0200, Pablo Neira Ayuso wrote:
> > > On Sun, Sep 10, 2023 at 09:30:18PM +0100, Jeremy Sowden wrote:
> > > > `mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer
> > > > length value, `len`, against which to compare the size of the
> > > > object expected to fit into the buffer, because they are intended
> > > > to validate the length and it may be negative in the case of
> > > > malformed messages.  Comparing this signed value against unsigned
> > > > operands leads to compiler warnings, so the unsigned operands are
> > > > cast to `int`.  Comparing `len` to the size of the structure is
> > > > fine, because the structures are only a few bytes in size.
> > > > Comparing it to the length fields of `struct nlmsg` and `struct
> > > > nlattr`, however, is problematic, since these fields may hold
> > > > values greater than `INT_MAX`, in which case the casts will yield
> > > > negative values and result in false positives.
> > > > 
> > > > Instead, assign `len` to an unsigned local variable, check for
> > > > negative values first, then use the unsigned local for the other
> > > > comparisons, and remove the casts.
> > > > 
> > > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1691
> > > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > > ---
> > > >  src/attr.c  | 9 +++++++--
> > > >  src/nlmsg.c | 9 +++++++--
> > > >  2 files changed, 14 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/src/attr.c b/src/attr.c
> > > > index bc39df4199e7..48e95019d5e8 100644
> > > > --- a/src/attr.c
> > > > +++ b/src/attr.c
> > > > @@ -97,9 +97,14 @@ EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
> > > >   */
> > > >  EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
> > > 
> > > Maybe turn this into uint32_t ?
> > 
> > Actually, attribute length field is 16 bits long, so it can never
> > happen that nla_len will underflow.
> 
> Oh, yeah.  Sorry.  I Thought I'd checked that.  I think my version
> without the casts is still tidier.  My preference would be to keep the
> nlattr change but amend the commit message, but if you prefer I'll drop
> it.

I would prefer to update documentation and drop the change for nlattr.

For mnl_attr_ok(), this should be sufficient?

        if (len < 0)
                return false;

to reject buffer larger that 2^31 (2 GBytes) or when length goes
negative (malformed netlink message in the buffer).

BTW, this _trivial_ function is modeled after nlmsg_ok() in the
kernel...

On Sun, Sep 10, 2023 at 09:30:18PM +0100, Jeremy Sowden wrote:
> `mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer length
> value, `len`, against which to compare the size of the object expected
> to fit into the buffer, because they are intended to validate the length       
> and it may be negative in the case of malformed messages.  Comparing           
> this signed value against unsigned operands leads to compiler warnings,        
> so the unsigned operands are cast to `int`.

Did you see such compiler warning? If so, post it in commit
description.

> Comparing `len` to the size of the structure is fine, because
> the structures are only a few bytes in size. Comparing it to
> the length fields of `struct nlmsg` and `struct nlattr`,
> however, is problematic, since these fields may hold values greater
> than `INT_MAX`, in which case the casts will yield negative values
> and result in false positives.

Yes, but the early check for negative length prevents this after this
patch, correct?

> Instead, assign `len` to an unsigned local variable, check for negative        
> values first, then use the unsigned local for the other comparisons, and       
> remove the casts.

Makes sense.

Probably I'm getting confused with this large patch description :)
