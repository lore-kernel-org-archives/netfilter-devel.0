Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1480FC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6DAC20815
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbfETMAU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:00:20 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35366 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730612AbfETMAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:00:20 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hSgxm-0008RX-Hp; Mon, 20 May 2019 14:00:18 +0200
Date:   Mon, 20 May 2019 14:00:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables 4/4] nft: keep old cache around until batch is
 refreshed in case of ERESTART
Message-ID: <20190520120018.GA31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190519115121.32490-1-pablo@netfilter.org>
 <20190519115121.32490-4-pablo@netfilter.org>
 <20190519164508.GL4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519164508.GL4851@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, May 19, 2019 at 06:45:08PM +0200, Phil Sutter wrote:
[...]
> The only way to make the above work is by keeping the original cache
> copy around until mnl_batch_talk has finally succeeded or failed with
> something else than ERESTART.

How about a completely different approach:

If memory serves right (and from reading the related Red Hat ticket),
the actual problem we're trying to solve is that iptables-nft-restore
creates NFT_MSG_DELTABLE only if that table exists already at the point
of parsing but another client might create it in the mean time before
committing.

My idea for solving this was to unconditionally create NFT_MSG_NEWTABLE
followed by NFT_MSG_DELTABLE - in case the table exists, the first one
is a noop; in case the table doesn't exist, the second one won't provoke
an error message from kernel space.

Since NFT_MSG_DELTABLE removes the table recursively, we don't need to
care about any content added by the other client.

Or is this about a generic solution for all commands not just
iptables-nft-restore (without --noflush)?

Cheers, Phil

