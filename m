Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062D7C05027
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Feb 2023 13:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjBBNDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjBBNDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2023 08:03:01 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91E798EB40;
        Thu,  2 Feb 2023 05:02:40 -0800 (PST)
Date:   Thu, 2 Feb 2023 14:02:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH net-next] ipvs: avoid kfree_rcu without 2nd arg
Message-ID: <Y9u0VuwiC3KGKOS7@salvia>
References: <20230201175653.114334-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230201175653.114334-1-ja@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 01, 2023 at 07:56:53PM +0200, Julian Anastasov wrote:
> Avoid possible synchronize_rcu() as part from the
> kfree_rcu() call when 2nd arg is not provided.

Applied to nf-next, thanks
