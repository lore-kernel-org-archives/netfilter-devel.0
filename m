Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39996C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Dec 2022 19:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiLSTlz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiLSTls (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 14:41:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9545613E8D
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2022 11:41:47 -0800 (PST)
Date:   Mon, 19 Dec 2022 20:41:44 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: Re: [PATCH nf,v2 4/4] netfilter: nf_tables: honor set timeout and
 garbage collection updates
Message-ID: <Y6C+eL5sXc6GT0Cg@salvia>
References: <20221219192844.212253-1-pablo@netfilter.org>
 <20221219192844.212253-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221219192844.212253-5-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 19, 2022 at 08:28:44PM +0100, Pablo Neira Ayuso wrote:
> Set timeout and garbage collection interval updates are ignored on
> updates. Add transaction to update global set element timeout and
> garbage collection interval.

I posted an incomplete version of 4/4, I'll follow up with a new
version for this one.
