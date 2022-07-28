Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC30C04A68
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 08:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiG1I4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 04:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiG1I4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 04:56:16 -0400
Received: from outgoing12.flk.host-h.net (outgoing12.flk.host-h.net [188.40.208.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B94F655B0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 01:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=risingedge.co.za; s=xneelo; h=Message-ID:References:In-Reply-To:Subject:Cc:
        To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version:reply-to:
        sender:bcc; bh=mQdOr3XI7ioMhBw5IW/BC3N5zWmrmFm18JebNOQR1Io=; b=oql6esq3QDaNYO
        Be6sksiEomEU8Si7iUyxKM7J+pRn8f6bFqlKD6RRka3osDAvmbqbEuk7jucBbZstU8wU/yk0/oSxf
        BMCPb2ERbMbCp61hRFfn6Px5ohhHSXKRVfT/QQjDSsLMSQPwwONnyatl4zNpkIFPEGv88KaQTJssE
        H1Z2ub7DgmXEw+NBeRfqu+LZQWf3DtFNHR7/6f42RtHhLWMtJhH5kaCI5XTcCGPWMIlGQ7dDHfpWt
        FgZYM9Xv3DroQdvaVQeUapuxzA5BjzvE4oxCgie6y9+FITjTECHWSzsieuYx/ZBsQOrQ1Zot8pXTP
        ovXTJmq56/TMh3Cu6dhg==;
Received: from www31.flk1.host-h.net ([188.40.1.173])
        by antispam3-flk1.host-h.net with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1oGzJJ-0007d5-2Q; Thu, 28 Jul 2022 10:56:08 +0200
Received: from roundcubeweb1.flk1.host-h.net ([138.201.244.33] helo=webmail9.konsoleh.co.za)
        by www31.flk1.host-h.net with esmtpa (Exim 4.92)
        (envelope-from <justin.swartz@risingedge.co.za>)
        id 1oGzJI-0007Su-9k; Thu, 28 Jul 2022 10:56:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Jul 2022 10:56:00 +0200
From:   Justin Swartz <justin.swartz@risingedge.co.za>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, rkolchmeyer@google.com,
        pablo@netfilter.org
Subject: Re: [PATCH resend] ebtables: extend the 'static' build target fix.
In-Reply-To: <YuJFD5/1y1rhhyCZ@strlen.de>
References: <20220625081441.13323-1-justin.swartz@risingedge.co.za>
 <42ed3ff1408e811918f138e1f1aefec1@risingedge.co.za>
 <YuJFD5/1y1rhhyCZ@strlen.de>
Message-ID: <e8710ee1bd03701352fb89dfcc385308@risingedge.co.za>
X-Sender: justin.swartz@risingedge.co.za
User-Agent: Roundcube Webmail/1.3.17
X-Authenticated-Sender: justin.swartz@risingedge.co.za
X-Virus-Scanned: Clear
X-Originating-IP: 188.40.1.173
X-SpamExperts-Domain: risingedge.co.za
X-SpamExperts-Username: 
Authentication-Results: host-h.net; auth=pass (login) smtp.auth=@risingedge.co.za
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.12)
X-Recommended-Action: accept
X-Filter-ID: Pt3MvcO5N4iKaDQ5O6lkdGlMVN6RH8bjRMzItlySaT+geq1cqfVyixSvgwtxKPbkPUtbdvnXkggZ
 3YnVId/Y5jcf0yeVQAvfjHznO7+bT5xntEluci+0hyorrNrHYHDz1gBL3A/jgxey63tL9TfYNUIt
 21NnLo1Lxyjhuus5kwwKW9sWwyYFlYTTZ48Qq31ZznUV/Bs9bwbqVU0orhg67S4TIW52pZm6lpzo
 LRTveWL+xIvF2YPOraOR7WdbmOke/KGVJwdEtxHtQ5nZL3g3VgTJsjWw5+0eZIpQIcK9yrTJeXoU
 xPozdon+5NjDz4Lpjd12v0hRQV2TuWFKPYIZhdEijaOYwIo3VWtNfh+T9pEV3Ptb+ZU+Z0HPYy6m
 EBi18U54yHbe0U2Q73dIPYtLRYxgb6PaYLiS14zYnAdK8AIV8bsd7WYc4sS5nxHe02gIZsN/DZ4i
 BHU1jKlc4dIeTtVzfBpUNIJbCsp5zJU0MGPpxOsB8gG0slV7ra6jI4BSJGlDdAt5iE2wWUUtBv7R
 wyGL9OyxAMsMu5TiHOeDBqW2s3BysOB3xpjrd5YzJziOi2bznHJ53CHS5fL+CC61pCZsm4iYatgr
 Ye8fqbmOW/SkIDJ+MiVFRiOp2cMOF3I6vCrJPmnnTHzVkpybMK7ZTdFnwBH6KS7vdcGZnFPEDmjB
 o9WPi4IE45J8SMIBWsA7UC4FahA5qoitJXNe5RxfYUHbpksF+Uf/PBuopB+R+LWB1R4c8SpbSl/z
 Imjpsfml8WF2VeyCHG6Wgx/xolPx8tBKNuisYrStde2dIjiiWgBIk6krh21EwctQ9Ij191Ndkspr
 Votsy2Wg/F23iule85BaCQ4fsNty+U1eVDaROUXhlz3SIJom9yXeeCrNObnUrjydPdMAYCO+eRwE
 NA+5ArHYhXQwhXELIBZC+BuxdgITIbXwR2snFsekbN2WcuVC3uP1GCj2SOP6Sno0pHt4TAuzPYHI
 sj91NoCnEZPoYOntuptTB2n+gg5ygHhLl0q6l6ACzEsMGeWTpZ/NLDHv5PB4agWOBURF9vZZEPKb
 P7YL/PyVSe2/DDFq5n7HBuKWZWWGwVvz5fzAKuWzP95bkbFuZA8ZSc8y6eaZ+9uhaKg2yPRk3H1E
 4ANRdN1BlPI5FzmGiR0+LS+gWFeuUoaxzghV2FSwgYONUpBsA1NBhDo=
X-Report-Abuse-To: spam@antispammaster.host-h.net
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2022-07-28 10:13, Florian Westphal wrote:
> Justin Swartz <justin.swartz@risingedge.co.za> wrote:
>> Assign "-all-static" (instead of "-static") to "static_LDFLAGS" in
>> Makefile.am, as libtool will only produce a static binary if it is
>> explicitly told that all of the linked libraries should be static.
> 
> Before libtool conversion "make static" did not create a static binary
> either.  It builds a version of ebtables that has libebtables.so
> baked in.
> 
> So, as far as I can see, "make static" does the same thing it
> did prio to automake/libtool conversion, place all the extensions
> and libebtables in the "static" binary, but link libc.so dynamically.

Thanks for the clarification.

I assumed "make static" was intended to produce an actual static binary.

As part of a small distribution that I use on a few bridging firewalls,
I have only ebtables and busybox, both built as static binaries, plus
inittab and a few init scripts.

I don't mind patching "Makefile.am" for myself, but I would also be 
happy
to submit something like the following, if nice-to-have, to provide an
"allstatic" which shouldn't break anything for those who require 
"static"
in its current form.

--%--

  sbin_PROGRAMS = ebtables-legacy ebtablesd ebtablesu 
ebtables-legacy-restore
-EXTRA_PROGRAMS = static examples/ulog/test_ulog
+EXTRA_PROGRAMS = allstatic static examples/ulog/test_ulog
  sysconf_DATA = ethertypes

  ...

  static_SOURCES = ebtables-standalone.c $(libebtc_la_SOURCES)
  static_LDFLAGS = -static
+allstatic_SOURCES = $(static_SOURCES)
+allstatic_LDFLAGS = -all-static
  examples_ulog_test_ulog_SOURCES = examples/ulog/test_ulog.c 
getethertype.c

--%--
