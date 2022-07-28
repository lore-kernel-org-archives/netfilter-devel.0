Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F369DC04A68
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 10:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiG1KhT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 06:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiG1KhQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 06:37:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FF657203
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 03:37:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oH0t9-0002kP-PR; Thu, 28 Jul 2022 12:37:07 +0200
Date:   Thu, 28 Jul 2022 12:37:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Justin Swartz <justin.swartz@risingedge.co.za>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        rkolchmeyer@google.com, pablo@netfilter.org
Subject: Re: [PATCH resend] ebtables: extend the 'static' build target fix.
Message-ID: <20220728103707.GB4816@breakpoint.cc>
References: <20220625081441.13323-1-justin.swartz@risingedge.co.za>
 <42ed3ff1408e811918f138e1f1aefec1@risingedge.co.za>
 <YuJFD5/1y1rhhyCZ@strlen.de>
 <e8710ee1bd03701352fb89dfcc385308@risingedge.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8710ee1bd03701352fb89dfcc385308@risingedge.co.za>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Justin Swartz <justin.swartz@risingedge.co.za> wrote:
> > So, as far as I can see, "make static" does the same thing it
> > did prio to automake/libtool conversion, place all the extensions
> > and libebtables in the "static" binary, but link libc.so dynamically.
> 
> Thanks for the clarification.
> 
> I assumed "make static" was intended to produce an actual static binary.
> 
> As part of a small distribution that I use on a few bridging firewalls,
> I have only ebtables and busybox, both built as static binaries, plus
> inittab and a few init scripts.
> 
> I don't mind patching "Makefile.am" for myself, but I would also be happy
> to submit something like the following, if nice-to-have, to provide an
> "allstatic" which shouldn't break anything for those who require "static"
> in its current form.

If you can't get what you need without patching the ebables build
scripts then sure, feel free to submit a change that allows to build a
fully static binary.
