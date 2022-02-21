Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E4C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 14:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378373AbiBUOvj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 09:51:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiBUOvj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 09:51:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16C175F80
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 06:51:16 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1112860225;
        Mon, 21 Feb 2022 15:50:19 +0100 (CET)
Date:   Mon, 21 Feb 2022 15:51:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH v3] netfilter: nf_tables: fix memory leak during stateful
 obj update
Message-ID: <YhOm4e8fdfZU9Qd5@salvia>
References: <20220221123149.11519-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220221123149.11519-1-fw@strlen.de>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 21, 2022 at 01:31:49PM +0100, Florian Westphal wrote:
> stateful objects can be updated from the control plane.
> The transaction logic allocates a temporary object for this purpose.
> 
> The ->init function was called for this object, so plain kfree() leaks
> resources. We must call ->destroy function of the object.
> 
> nft_obj_destroy does this, but it also decrements the module refcount,
> but the update path doesn't increment it.
> 
> To avoid special-casing the update object release, do module_get for
> the update case too and release it via nft_obj_destroy().

Also applied, thanks
