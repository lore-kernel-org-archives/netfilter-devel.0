Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDDDC4167B
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Dec 2022 16:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiLUQsG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiLUQsF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 11:48:05 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E77C24BFC
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Dec 2022 08:48:05 -0800 (PST)
Date:   Wed, 21 Dec 2022 17:48:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH 0/4] Fix some minor bugs
Message-ID: <Y6M4wXLf+OjKAkq2@salvia>
References: <20221220153847.24152-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221220153847.24152-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 20, 2022 at 04:38:43PM +0100, Phil Sutter wrote:
> All these were identified by Covscan.

Series LGTM.
