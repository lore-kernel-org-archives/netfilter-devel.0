Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C19FC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 21:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhLOVvz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 16:51:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56178 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhLOVvz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 16:51:55 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 30653625F1;
        Wed, 15 Dec 2021 22:49:26 +0100 (CET)
Date:   Wed, 15 Dec 2021 22:51:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] build: fix autoconf warnings
Message-ID: <Ybpjd2pO2LYMlrcy@salvia>
References: <20211215184440.39507-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211215184440.39507-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 15, 2021 at 06:44:40PM +0000, Jeremy Sowden wrote:
> autoconf complains about three obsolete macros.
> 
> `AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`, so
> replace it.
> 
> `AM_PROG_LEX` calls `AC_PROG_LEX` with no arguments, but this usage is
> deprecated.  The only difference between `AM_PROG_LEX` and `AC_PROG_LEX`
> is that the former defines `$LEX` as "./build-aux/missing lex" if no lex
> is found to ensure a useful error is reported when make is run.  How-
> ever, the configure script checks that we have a working lex and exits
> with an error if none is available, so `$LEX` will never be called and
> we can replace `AM_PROG_LEX` with `AC_PROG_LEX`.
> 
> `AM_PROG_LIBTOOL` has been superseded by `LT_INIT`, which is already in
> configure.ac, so remove it.
> 
> We can also replace `AC_DISABLE_STATIC` with an argument to `LT_INIT`.

Also applied, thanks.
