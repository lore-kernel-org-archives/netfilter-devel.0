Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED8DC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiBDFTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:19:08 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49184 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiBDFTH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 00:19:07 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B41DB60014;
        Fri,  4 Feb 2022 06:19:01 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:19:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: conntrack: remove extension
 register api
Message-ID: <Yfy3R7rtdo9pFsGa@salvia>
References: <20220120120702.15939-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220120120702.15939-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 20, 2022 at 01:06:58PM +0100, Florian Westphal wrote:
> This starts to simplify the extension infra. Should have no impact
> on functionality.
> 
> Extension IDs already need compile-time allocation, the dynamic
> registration isn't necessary, just place the sizes in the extension
> core and handle the only instance of the ->destroy hook manually.
> 
> Also avoids the ->destroy hook invocation during ct destruction if
> the conntrack wasn't added to the bysource hash list.

Series applied.
