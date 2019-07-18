Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9743C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 14:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C731D2080D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 14:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGRO51 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:57:27 -0400
Received: from mail.us.es ([193.147.175.20]:52248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfGRO51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 10:57:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9EFA6D4F5
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 16:57:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB879A6DA
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 16:57:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D0CA011510A; Thu, 18 Jul 2019 16:57:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B70D21150CB;
        Thu, 18 Jul 2019 16:57:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 16:57:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 900E840705C7;
        Thu, 18 Jul 2019 16:57:22 +0200 (CEST)
Date:   Thu, 18 Jul 2019 16:57:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: json_cmd_assoc and cmd
Message-ID: <20190718145722.k5nnznt753cunnca@salvia>
References: <20190716183101.pev5gcmk3agqwpsm@salvia>
 <20190716190224.GB31548@orbyte.nwl.cc>
 <20190716193903.44zquiylov2p452g@salvia>
 <20190718123704.GA31345@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190718123704.GA31345@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 18, 2019 at 01:37:04PM +0100, Jeremy Sowden wrote:
> On 2019-07-16, at 21:39:03 +0200, Pablo Neira Ayuso wrote:
> > BTW, not directly related to this, but isn't this strange?
> >
> >         list_for_each_entry(cmd, cmds, list) {
> >                 memset(&ctx, 0, sizeof(ctx));
> >                 ctx.msgs = msgs;
> >                 ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> >                 ctx.batch = batch;
> >                 ctx.nft = nft;
> >                 init_list_head(&ctx.list);
> >                 ret = do_command(&ctx, cmd);
> >                 ...
> >
> > ctx is reset over and over again. Then, recycled here:
> >
> >                 ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
> >
> > I wonder if we can get this better.
> 
> Something like this?

Yes, something like that would get things in better shape I think,
more comments below.

> 	struct netlink_ctx ctx = { .msgs = msgs, .nft = nft };
>         ...
> 
> 	ctx.batch = batch = mnl_batch_init();
> 	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
> 	list_for_each_entry(cmd, cmds, list) {
> 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> 		init_list_head(&ctx.list);

I think we don't need to re-initialize this list over and over again
(from what I see when doing: git grep "ctx->list").

This always does list_splice_tail_init() to attach the object list
where they belong.

You can probably add something like:

        if (!list_empty(&ctx->list))
                BUG("command list is not empty\n");

I would make a patch and run tests/shell and tests/py to check if what
I'm suggesting this fine :-)

> 		ret = do_command(&ctx, cmd);
> 		...

Thanks!
