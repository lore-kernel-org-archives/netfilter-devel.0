Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A94C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D29E60F90
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbhJ0Jdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:33:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47808 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240988AbhJ0Jdt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 05:33:49 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 75A0960098;
        Wed, 27 Oct 2021 11:29:35 +0200 (CEST)
Date:   Wed, 27 Oct 2021 11:31:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] parser: extend limit statement syntax.
Message-ID: <YXkcZzCwBufryOqc@salvia>
References: <20211002152230.1568537-1-jeremy@azazel.net>
 <YVnFGPHsva1xm7F+@azazel.net>
 <YXkaInao+hLzLkR7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YXkaInao+hLzLkR7@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 11:21:42AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Oct 03, 2021 at 03:58:32PM +0100, Jeremy Sowden wrote:
> > On 2021-10-02, at 16:22:30 +0100, Jeremy Sowden wrote:
> > > The documentation describes the syntax of limit statements thus:
> > >
> > >   limit rate [over] packet_number / TIME_UNIT [burst packet_number packets]
> > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > >
> > >   TIME_UNIT := second | minute | hour | day
> > >   BYTE_UNIT := bytes | kbytes | mbytes
> > >
> > > This implies that one may specify a limit as either of the following:
> > >
> > >   limit rate 1048576 / second
> > >   limit rate 1048576 mbytes / second
> > >
> > > However, the latter currently does not parse:
> > >
> > >   $ sudo /usr/sbin/nft add filter input limit rate 1048576 mbytes / second
> > >   Error: wrong rate format
> > >   add filter input limit rate 1048576 mbytes / second
> > >                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> > >
> > > Extend the parser to support it.
> > >
> > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > ---
> > >
> > > I can't help thinking that it ought to be possible to fold the two
> > >
> > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > >
> > > rules into one.  However, my attempts to get the scanner to tokenize
> > > "bytes/second" as "bytes" "/" "second" (for example) failed.
> > 
> > Having reread the Flex manual, I've changed my mind.  While it would be
> > possible, it would be rather fiddly and require more effort than it
> > would be worth.
> 
> I can apply this workaround meanwhile we have a better solution for
> this if this is an issue on your side.
> 
> Did you get any bug report regarding this?

Another possibility is to remove the existing call to rate_parse().

the bison parser accepts both:

add filter input limit rate 1048576 mbytes / second
add filter input limit rate 1048576 mbytes/second

after your update, right? I'm missing a few deletions in this previous
(the existing rules). I think there's a way to consolidate this bison
rule.
