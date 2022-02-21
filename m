Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722C7C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 11:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355795AbiBULNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 06:13:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355443AbiBULMb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 06:12:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC95615D
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 02:46:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nM6DD-0000MQ-81; Mon, 21 Feb 2022 11:46:35 +0100
Date:   Mon, 21 Feb 2022 11:46:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH v2 nf] netfilter: nf_tables: fix memory leak during
 stateful obj update
Message-ID: <20220221104635.GB18967@breakpoint.cc>
References: <20220220111850.87378-1-fw@strlen.de>
 <YhNqmSBAt2IRbYx6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhNqmSBAt2IRbYx6@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Feb 20, 2022 at 12:18:50PM +0100, Florian Westphal wrote:
> > stateful objects can be updated from the control plane.
> > The transaction logic allocates a temporary object for this purpose.
> > 
> > This object has to be released via nft_obj_destroy, not kfree, since
> > the ->init function was called and it can have side effects beyond
> > memory allocation.
> > 
> > Unlike normal NEWOBJ path, the objects module refcount isn't
> > incremented, so add nft_newobj_destroy and use that.
> 
> Probably this? .udata and .key is NULL for the update path so kfree
> should be fine.

Yes, that works too.

We could also ...

> -	module_put(obj->ops->type->owner);
> +	/* nf_tables_updobj does not increment module refcount */
> +	if (!update)
> +		module_put(obj->ops->type->owner);
> +

Increment the refcount for update case as well to avoid the special
case?
