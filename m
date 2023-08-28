Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489CEC71153
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 19:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjH1Txs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 15:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjH1TxP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 15:53:15 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6672186
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 12:53:11 -0700 (PDT)
Received: from [78.30.34.192] (port=59182 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qaiIL-00BIhV-57; Mon, 28 Aug 2023 21:53:07 +0200
Date:   Mon, 28 Aug 2023 21:53:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/8] src: rework SNPRINTF_BUFFER_SIZE() and avoid
 "-Wunused-but-set-variable"
Message-ID: <ZOz7IMG0J1B0HVlB@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
 <20230828144441.3303222-6-thaller@redhat.com>
 <ZOy5nTEQJvu7zdrx@calendula>
 <aa481d83b0320078a17bebf215378992a4f7cb21.camel@redhat.com>
 <ZOzFgtwJI6AasAYZ@calendula>
 <31efcb8e9ceac6f71003abd9517cca981550fc91.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <31efcb8e9ceac6f71003abd9517cca981550fc91.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 06:45:00PM +0200, Thomas Haller wrote:
> On Mon, 2023-08-28 at 18:04 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Aug 28, 2023 at 05:49:53PM +0200, Thomas Haller wrote:
> > > On Mon, 2023-08-28 at 17:13 +0200, Pablo Neira Ayuso wrote:
> > 
> > > SNPRINTF_BUFFER_SIZE() rejects truncation of the string by
> > > asserting
> > > against it. That behavior is part of the API of that function.
> > > Error
> > > checking after an assert seems unnecessary.
> > > 
> > > The check "if (len == NF_LOG_PREFIXLEN)" seems wrong anyway. After
> > > truncation, "len" would be zero. The code previously checked
> > > whether
> > > nothing was appended, but the error string didn't match that
> > > situation.
> > > 
> > > Maybe SNPRINTF_BUFFER_SIZE() should not assert against truncation?
> > 
> > IIRC, the goal for this function was to handle snprintf() and all its
> > corner cases. If there is no need for it or a better way to do this,
> > this is welcome.
> > 
> 
> I think the macro is sensible (at least, after some cleanup).
> 
> It makes a choice, that the caller must ensure a priori that the buffer
> is long enough (by asserting).
> 
> By looking at the callers, it's not clear to me, whether the callers
> can always ensure that.  For meta_key_parse(), it seems the maximum
> string is limited by meta_templates. But for stmt_evaluate_log_prefix()
> it may be possible to craft user-input that triggers the assertion,
> isn't it?
> 
> Maybe the macro and the callers should anticipate and handle
> truncation?

This should not silently truncate strings, instead bail out to user in
case the string is too long.

#define NF_LOG_PREFIXLEN       128

Maximum length as specified by uapi/linux/netfilter/nf_log.h

Currently in userspace, if I specify a string longest than that, I can
see ASAN complains on incorrect memory management from userspace
(without your patchset), so this code is currently broken (by me
mostly likely since I was the last one to touch those bits).

While at this, it would be good to fix it and add a test to cover
maximum prefix length.

Regarding meta_key_parse(), these days the preferred approach is to
use start conditions in flex. This function should go away, it was an
early attempt to reduce tokens by using STRING from bison, which
turned out to be flawed.

It is not worth to fix meta_key_parse(), flex start conditions and
bison parser should be used.

This macro is hiding behind a bit of technical debt.
