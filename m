Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1066C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 21:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhLOVv2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 16:51:28 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56164 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhLOVv1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 16:51:27 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C12E9625F1;
        Wed, 15 Dec 2021 22:48:58 +0100 (CET)
Date:   Wed, 15 Dec 2021 22:51:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] tests: shell: remove stray debug flag.
Message-ID: <YbpjW05KHwhzq37f@salvia>
References: <20211215184341.39427-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211215184341.39427-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 15, 2021 at 06:43:41PM +0000, Jeremy Sowden wrote:
> 0040mark_shift_0 was passing --debug=eval to nft.  Remove it.

Applied, thanks.
