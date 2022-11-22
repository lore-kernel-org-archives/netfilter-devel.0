Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AE7C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 18:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiKVSFl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 13:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiKVSFk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 13:05:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D479369DFC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 10:05:39 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oxXeM-0007ph-Ab
        for netfilter-devel@vger.kernel.org; Tue, 22 Nov 2022 19:05:38 +0100
Date:   Tue, 22 Nov 2022 19:05:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: mark: Test double bitwise in a rule
Message-ID: <Y30Pcu0JbYbkwx6Z@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20221116110142.17346-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116110142.17346-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 16, 2022 at 12:01:42PM +0100, Phil Sutter wrote:
> In v1.8.8, the second bitwise changed the first one, messing
> iptables-nft-save output.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Applied.
