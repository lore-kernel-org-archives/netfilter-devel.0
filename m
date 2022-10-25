Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A966EC38A2D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 11:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiJYLDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJYLDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 07:03:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54A911413B7
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2022 04:03:01 -0700 (PDT)
Date:   Tue, 25 Oct 2022 13:02:57 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3] src: add support to command "destroy"
Message-ID: <Y1fCYSWGl63YR1V0@salvia>
References: <20221024110122.1248-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221024110122.1248-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 24, 2022 at 01:01:22PM +0200, Fernando Fernandez Mancera wrote:
> "destroy" command performs a deletion as "delete" command but does not fail
> when the object does not exist. As there is no NLM_F_* flag for ignoring such
> error, it needs to be ignored directly on error handling.
> 
> Example of use:
> 
> 	# nft list ruleset
>         table ip filter {
>                 chain output {
>                 }
>         }
>         # nft destroy table ip missingtable
> 	# echo $?
> 	0
>         # nft list ruleset
>         table ip filter {
>                 chain output {
>                 }
>         }

Looks good, but this will also require a small patch in kernel.
Ignoring the return value is not sufficient for the transaction
semantics, considering the following example batch to be loaded via
nft -f:

        destroy table ip xyz

        table ip xyz {
        }

so the transaction does not fail.

Kernel patch would be similar to what nf_conntrack_netlink.c does with
IPCTNL_MSG_CT_GET_CTRZERO.

You have to define a new command NFT_MSG_DESTROYTABLE, then register a
new entry in nfnl_callback that refers to nf_tables_deltable. Then,
from nf_tables_deltable:

        if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_DESTROYTABLE)
                return 0;

        return -ENOENT;

to silence the error reporting.

Keep it mind that:

  nft flush table ip x

leaves the table in place, but:

  nft delete table ip x

removes the table and its content (but it fails if table does not
exists).

What we need from kernel is the destroy semantics, it should be a
relatively small patch.

Thanks Fernando.
