Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E80DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 12:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BE060EDF
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 12:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhKBMER (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 08:04:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60528 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhKBMER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 08:04:17 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 31B99605BA;
        Tue,  2 Nov 2021 12:59:49 +0100 (CET)
Date:   Tue, 2 Nov 2021 13:01:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_log PATCH] build: fix pkg-config syntax-errors
Message-ID: <YYEooqEED/HI87z9@salvia>
References: <20211030121546.1072767-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211030121546.1072767-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 30, 2021 at 01:15:46PM +0100, Jeremy Sowden wrote:
> pkg-config config-files require back-slashes when definitions are folded
> across multiple lines.

Applied, thanks.
