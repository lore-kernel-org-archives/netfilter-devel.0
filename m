Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BAEC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 12:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhLQMSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 07:18:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60980 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbhLQMSh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 07:18:37 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0081B605B9;
        Fri, 17 Dec 2021 13:16:06 +0100 (CET)
Date:   Fri, 17 Dec 2021 13:18:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] build: remove scanner.c and parser_bison.c with
 `maintainer-clean`
Message-ID: <YbyAGTf19hxDxzGE@salvia>
References: <20211216163720.180125-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211216163720.180125-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 04:37:20PM +0000, Jeremy Sowden wrote:
> automake recommends shipping the output of bison and lex in distribution
> tar-balls and runs bison and lex during `make dist` (this has the
> advantage that end-users don't need to have bison or lex installed to
> compile the software).  Accordingly, automake also recommends removing
> these files with `make maintainer-clean` and generates rules to do so.
> Therefore, remove scanner.c and parser_bison.c from `CLEANFILES`.

Applied, thanks
