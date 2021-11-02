Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971F3C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 11:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B01660295
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 11:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhKBLq6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 07:46:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60372 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhKBLq5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 07:46:57 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 81B3063F5C;
        Tue,  2 Nov 2021 12:42:28 +0100 (CET)
Date:   Tue, 2 Nov 2021 12:44:17 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v2 0/3] parser: refactor and extend limit rate rules
Message-ID: <YYEkka0RD6qjI4Yq@salvia>
References: <20211029204009.954315-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211029204009.954315-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 29, 2021 at 09:40:06PM +0100, Jeremy Sowden wrote:
> The first two patches introduce new rules to deduplicate the code for
> parsing `limit rate` expressions and make it easier to extend the
> syntax.
> 
> The third patch extends the syntax to handle expressions like `limit
> rate 1 mbytes / second`, which are not currently supported.

Series applied, thanks.
