Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F131C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EDD60EFE
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhJKXGP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:06:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39274 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhJKXGP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 19:06:15 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1487B63EEE;
        Tue, 12 Oct 2021 01:02:39 +0200 (CEST)
Date:   Tue, 12 Oct 2021 01:04:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v3 0/3] Stateless output fixes
Message-ID: <YWTC6gatBa2JIcQj@salvia>
References: <20211007201222.2613750-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211007201222.2613750-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 07, 2021 at 09:12:19PM +0100, Jeremy Sowden wrote:
> The first patch removes some dummy output for named counters.  The
> second patch fixes a bug that erroneously clears the stateless output
> flag.  The third patch merges some conditionals.

Series applied, thanks.
