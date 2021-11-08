Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18FDC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D615361242
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhKHKk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:40:29 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46896 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238365AbhKHKk1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:40:27 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1F13B606B2;
        Mon,  8 Nov 2021 11:35:45 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:37:39 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: do not erase error code with
 EINVAL
Message-ID: <YYj986xSGwzq/RjX@salvia>
References: <20211103222155.17981-1-florent.fourcot@wifirst.fr>
 <20211103222155.17981-2-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211103222155.17981-2-florent.fourcot@wifirst.fr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 03, 2021 at 11:21:55PM +0100, Florent Fourcot wrote:
> And be consistent in error management for both orig/reply filtering

Also applied.
