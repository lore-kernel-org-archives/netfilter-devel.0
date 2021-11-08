Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09774C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D57F560EBC
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhKHKkP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:40:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46880 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhKHKkM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:40:12 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 33C896063C;
        Mon,  8 Nov 2021 11:35:29 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:37:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix filtering with
 CTA_TUPLE_REPLY
Message-ID: <YYj95EwfUohhmlev@salvia>
References: <20211103222155.17981-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211103222155.17981-1-florent.fourcot@wifirst.fr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 03, 2021 at 11:21:54PM +0100, Florent Fourcot wrote:
> filter->orig_flags was used for a reply context.

Applied, thanks
