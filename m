Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94851C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 14:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378374AbiBUOvh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 09:51:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378444AbiBUOvf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 09:51:35 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DE62220E9
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 06:51:04 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C3BD360225;
        Mon, 21 Feb 2022 15:50:06 +0100 (CET)
Date:   Mon, 21 Feb 2022 15:51:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_limit: fix stateful object memory leak
Message-ID: <YhOm1dzUXkg6Wqvh@salvia>
References: <20220218121705.3475-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220218121705.3475-1-fw@strlen.de>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 18, 2022 at 01:17:05PM +0100, Florian Westphal wrote:
> We need to provide a destroy callback to release the extra fields.

Applied to nf, thanks
