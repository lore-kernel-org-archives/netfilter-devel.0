Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB348E82CAE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjI0RLN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0RLN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 13:11:13 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42ACFB
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:11:11 -0700 (PDT)
Received: from [78.30.34.192] (port=49306 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlY43-00DeKF-Vs; Wed, 27 Sep 2023 19:11:10 +0200
Date:   Wed, 27 Sep 2023 19:11:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
Message-ID: <ZRRiK70d4FJUJgsP@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
 <20230927122744.3434851-3-thaller@redhat.com>
 <ZRRbgRny2AHfvV5H@calendula>
 <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 07:04:57PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-27 at 18:42 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 27, 2023 at 02:23:27PM +0200, Thomas Haller wrote:
> > > We almost can compile everything with "-Wstrict-overflow" (which
> > > depends
> > > on the optimization level). In a quest to make that happen, rework
> > > nf_osf_parse_opt(). Previously, gcc-13.2.1-1.fc38.x86_64 warned:
> > > 
> > >     $ gcc -Iinclude "-DDEFAULT_INCLUDE_PATH=\"/usr/local/etc\"" -c
> > > -o tmp.o src/nfnl_osf.c -Werror -Wstrict-overflow=5 -O3
> > >     src/nfnl_osf.c: In function ‘nfnl_osf_load_fingerprints’:
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >       356 | int nfnl_osf_load_fingerprints(struct netlink_ctx *ctx,
> > > int del)
> > >           |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >     src/nfnl_osf.c:356:5: error: assuming signed overflow does not
> > > occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > > Werror=strict-overflow]
> > >     cc1: all warnings being treated as errors
> > > 
> > > The previous code was needlessly confusing. Keeping track of an
> > > index
> > > variable "i" and a "ptr" was redundant. The signed "i" variable
> > > caused a
> > > "-Wstrict-overflow" warning, but it can be dropped completely.
> > > 
> > > While at it, there is also almost no need to ever truncate the bits
> > > that
> > > we parse. Only the callers of the new skip_delim_trunc() required
> > > the
> > > truncation.
> > > 
> > > Also, introduce new skip_delim() and skip_delim_trunc() methods,
> > > which
> > > point right *after* the delimiter to the next word.  Contrary to
> > > nf_osf_strchr(), which leaves the pointer at the end of the
> > > previous
> > > part.
> > > 
> > > Also, the parsing code using strchr() requires that the overall
> > > buffer
> > > (obuf[olen]) is NUL terminated. And the caller in fact ensured that
> > > too.
> > > There is no point in having a "olen" parameter, we require the
> > > string to
> > > be NUL terminated (which already was implicitly required).  Drop
> > > the
> > > "olen" parameter. On the other hand, it's unclear what ensures that
> > > we
> > > don't overflow the "opt" output buffer. Pass a "optlen" parameter
> > > and
> > > ensure we don't overflow the buffer.
> > 
> > Nice.
> > 
> > IIRC, this code was copied and pasted from iptables. Maybe porting
> > this patch there would be also good.
> 
> I will do that, after the patch was merged (and the final version
> known).
> 
> > BTW, did you test this patch with the pf.os file that nftables ships
> > in?
> 
> Right. I need to point out, that I did not test this. So it might be
> horribly broken. My Fedora kernel builds without CONFIG_NFT_OSF, so the
> shell tests are skipped.
> 
> How can pf.os used?

According to code, pf.os file with signatures needs to be placed here:

#define OS_SIGNATURES DEFAULT_INCLUDE_PATH "/nftables/osf/pf.os"

then, you can start matching on OS type, see 'osf' expression in
manpage. Note there is a "unknown" OS type when it does not guess the OS.
