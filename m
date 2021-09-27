Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DBAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 08:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6D26113A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 08:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhI0Ife (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 04:35:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54144 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhI0Ifd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 04:35:33 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 116A763EB4;
        Mon, 27 Sep 2021 10:32:31 +0200 (CEST)
Date:   Mon, 27 Sep 2021 10:33:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [conntrack-tools 0/6] Build fixes
Message-ID: <YVGB7Rhm7RNDPA8i@salvia>
References: <20210925151035.850310-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210925151035.850310-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 25, 2021 at 04:10:29PM +0100, Jeremy Sowden wrote:
> The first three patches contain changes suggested by autoupdate.  Four
> and five bring the handling of the yacc- and lex-generated sources more
> in line with the automake doc's.  The last one fixes a race in parallel
> builds.

Series applied, thanks.
