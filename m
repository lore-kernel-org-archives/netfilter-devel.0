Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C594EC38A24
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 14:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34D32082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 14:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgEGOLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 10:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgEGOLu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 10:11:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BA9C05BD43
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 07:11:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jWhFc-0002Ag-4u; Thu, 07 May 2020 16:11:48 +0200
Date:   Thu, 7 May 2020 16:11:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: Re: [PATCH nft] mnl: fix error rule reporting with missing
 table/chain and anonymous sets
Message-ID: <20200507141148.GN32392@breakpoint.cc>
References: <20200507112919.21227-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507112919.21227-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Program received signal SIGSEGV, Segmentation fault.
> 0x00007ffff7f64f1e in erec_print (octx=0x55555555d2c0, erec=0x55555555fcf0, debug_mask=0) at erec.c:95
> 95              switch (indesc->type) {
> (gdb) bt
>     buf=0x55555555db20 "add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept") at libnftables.c:459
> (gdb) p indesc
> $1 = (const struct input_descriptor *) 0x0
> 
> Closes: http://bugzilla.opensuse.org/show_bug.cgi?id=1171321
> Fixes: 086ec6f30c96 ("mnl: extended error support for create command")
> Reported-by: Jan Engelhardt <jengelh@inai.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Yes, but there is something else going on.

The command above works without this patch if you use a shorter table name.
There is another bug that causes nft to pull the wrong error object
from the queue.

The kernel doesn't generate an error for NFTA_SET_NAME in the above
rule, so we should not crash even without this (correct) fix, because
nft should not find this particular error object.

Seems the generated error is for NFTA_SET_ELEM_LIST_TABLE when handling
nf_tables_newsetelem() in kernel (which makes sense, the table doesn't
exist).

With the above command (traffic-filter) NFTA_SET_NAMEs start offset
matches the offset of NFTA_SET_ELEM_LIST_TABLE error message in the
other netlink message (the one adding the element to the set), it will
erronously find the cmd_add_loc() of NFTA_SET_NAME and then barf because
of the bug fixed here.

Not sure how to fix nft_cmd_error(), it looks like the error queueing assumes
1:1 mapping of cmd struct and netlink message header...?
