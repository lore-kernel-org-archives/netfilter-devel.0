Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6D0C4363C
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 14:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E788521924
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 14:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgJHOjb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 10:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbgJHOjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 10:39:31 -0400
X-Greylist: delayed 383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Oct 2020 07:39:31 PDT
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0A9C061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 07:39:31 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 87EBC58757E96; Thu,  8 Oct 2020 16:33:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 871B760E6E48A;
        Thu,  8 Oct 2020 16:33:04 +0200 (CEST)
Date:   Thu, 8 Oct 2020 16:33:04 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libiptc: Avoid gcc-10 zero-length array
 warning
In-Reply-To: <20201008130116.25798-1-phil@nwl.cc>
Message-ID: <s95qopq1-3o5o-oo9-1qso-osp024914p67@vanv.qr>
References: <20201008130116.25798-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-10-08 15:01, Phil Sutter wrote:

>Gcc-10 doesn't like the use of zero-length arrays as last struct member
>to denote variable sized objects.

On the contrary. It does not complain about the declaration of T x[0],
but about the write beyond the end of an array of size 0 (literally).
Such past-end writes are Undefined Behavior by the standard, and tools
like cov-scan (based on llvm I believe) report it just the same.

That's why C99 probably had to come up with "T y[]"; the array is now
of unspecified size rather than size 0. cov-scan agrees.

Since GCC has retained "T x[0]" as an extension, it would be a gcc bug
to warn about its own extension in conjunction with memcpy.


>The suggested alternative, namely to
>use a flexible array member as defined by C99, is problematic as that
>doesn't allow for said struct to be embedded into others.

Both T x[0] and T y[], in gcc, invoke the flexible scheme.

Both share the "embedding problem" - i.e. by using the flexible array,
you can accidentally access members of the surrounding struct.

gcc only complains about this when combining "T y[]" with C++ mode.
I find this to be an unusual choice and would suggest opening a bug.

The reason T x[0], when embedded, in C++, does not elicit a warning
is probably because it is already considered UB to access past-end-of-array
(see above); and I raise the hypothesis that the GNU extension of T x[0] is
actually only specified for C.

Anyway, gcc-10/C mode does not reject embedding (and a number of maintainers
have made it abundantly clear in the past they don't care if UAPI uses anti-C++
"features"). Nonreject example:

» cat x.c
struct a2 {
        int x;
        int z[];
};
struct m {
        struct a2 y;
        long q;
};
» gcc -Wall -std=c11 -c -w -v x.c
GNU C11 (SUSE Linux) version 10.2.1 20200825 [revision c0746a1beb1ba073c7981eb09f55b3d993b32e5c] (x86_64-suse-linux)
»


