Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557A8C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Dec 2022 14:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbiLNOtQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 09:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiLNOtP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 09:49:15 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E9D23EBA
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2022 06:49:14 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p5T4L-0003y8-7n; Wed, 14 Dec 2022 15:49:13 +0100
Date:   Wed, 14 Dec 2022 15:49:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] Makefile: Create LZMA-compressed dist-files
Message-ID: <Y5niaUn3WKVn/KPX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20221208003043.11712-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208003043.11712-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 01:30:43AM +0100, Phil Sutter wrote:
> Use a more modern alternative to bzip2.
> 
> Suggested-by: Jan Engelhardt <jengelh@inai.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
