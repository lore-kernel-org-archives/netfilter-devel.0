Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDEAC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B343360F9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhJ0Iri (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:47:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47652 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbhJ0Iri (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 04:47:38 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D0E6163F04;
        Wed, 27 Oct 2021 10:43:23 +0200 (CEST)
Date:   Wed, 27 Oct 2021 10:45:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v6] build: doc: Allow to specify
 whether to produce man pages, html, neither or both
Message-ID: <YXkRlNOxgVJxP/+r@salvia>
References: <20211018041739.13989-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211018041739.13989-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 03:17:39PM +1100, Duncan Roe wrote:
> New default action is: run doxygen (if installed) to produce man pages only.
> This adds 124 KB to the build tree (and to the install tree, after
> `make install`).
> For finer control of built documentation, the old --with-doxygen configure
> option is removed. Instead there are 2 new options:
>   --enable-html-doc      # +1160 KB
>   --disable-man-pages    #  -124 KB
> If doxygen is not installed, configure outputs a warning that man pages will not
> be built. configure --disable-man-pages avoids this warning.
> After --enable-html-doc
>  - `make install` installs built pages in htmldir instead of just leaving them
>    in the build tree.
>  - If the 'dot' program is not installed, configure outputs a warning that
>    interactive diagrams will be missing and to install graphviz to get them.
>    (There is an interactive diagram at the head of some modules, e.g.
>     User-space network packet buffer).

Applied, thanks
