Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F49CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CDE661179
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhKHKLj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:11:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46698 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbhKHKLi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:11:38 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C0B9B6063C;
        Mon,  8 Nov 2021 11:06:55 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:08:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v2 00/27] Compiler Warning Fixes
Message-ID: <YYj3MZu+JG0G9zhj@salvia>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 06, 2021 at 04:49:26PM +0000, Jeremy Sowden wrote:
> This patch-set fixes all the warnings reported by gcc 11.
> 
> Patch 1 adds the `format` GCC attribute to ulogd_log.
> Patches 2-5 fix the format errors revealed by the patch 1.
> Patches 6-8 fix fall-through warnings.
> Patches 9-10 are flow-control improvements related to patch 8.
> Patch 11 replaces malloc+memset with calloc.
> Patches 12-14 fix string-truncation warnings.
> Patch 15 fixes a possible unaligned pointer access.
> Patch 16 fixes DBI deprecation warnings.
> Patches 17-20 fix more truncation warnings.
> Patch 21 adds error-checking to sqlite SQL preparation.
> Patches 22-26 fix more truncation and format warnings.
> Patches 27 removes some superfluous preprocessor macros.

Please, add a description to your patches. Thanks.
