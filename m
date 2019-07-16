Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA82C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F3A21743
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbfGPTjH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 15:39:07 -0400
Received: from mail.us.es ([193.147.175.20]:49664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbfGPTjH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 15:39:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0A87BEBA3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 21:39:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1C99DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 21:39:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A77A9DA4D1; Tue, 16 Jul 2019 21:39:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF629DA708;
        Tue, 16 Jul 2019 21:39:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 21:39:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A08B14265A2F;
        Tue, 16 Jul 2019 21:39:03 +0200 (CEST)
Date:   Tue, 16 Jul 2019 21:39:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: json_cmd_assoc and cmd
Message-ID: <20190716193903.44zquiylov2p452g@salvia>
References: <20190716183101.pev5gcmk3agqwpsm@salvia>
 <20190716190224.GB31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716190224.GB31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 09:02:24PM +0200, Phil Sutter wrote:
> Hi Pablo,
>
> On Tue, Jul 16, 2019 at 08:31:01PM +0200, Pablo Neira Ayuso wrote:
> > Why json_cmd_assoc is not placed in struct cmd instead? I mean, just
> > store the json_t *json in cmd?
>
> The global list (json_cmd_list) is used in json_events_cb(). Unless I
> miss something, the cmd list is not available from struct
> netlink_mon_handler.

I see, thanks for explaining.

> Maybe I could move struct cmds list head into struct nft_ctx?

Probably place this in netlink_ctx?

We could also store num_cmds there too.

BTW, not directly related to this, but isn't this strange?

        list_for_each_entry(cmd, cmds, list) {
                memset(&ctx, 0, sizeof(ctx));
                ctx.msgs = msgs;
                ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
                ctx.batch = batch;
                ctx.nft = nft;
                init_list_head(&ctx.list);
                ret = do_command(&ctx, cmd);
                ...

ctx is reset over and over again. Then, recycled here:

                ret = mnl_batch_talk(&ctx, &err_list, num_cmds);

I wonder if we can get this better.
