Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFB4E8FDB3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 20:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjJCUsf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjJCUsf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 16:48:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3936AB;
        Tue,  3 Oct 2023 13:48:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnmJg-0004c5-P8; Tue, 03 Oct 2023 22:48:28 +0200
Date:   Tue, 3 Oct 2023 22:48:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 3/3] netfilter: nf_tables: Audit log object reset once
 per table
Message-ID: <20231003204828.GA15013@breakpoint.cc>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923015351.15707-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> When resetting multiple objects at once (via dump request), emit a log
> message per table (or filled skb) and resurrect the 'entries' parameter
> to contain the number of objects being logged for.
> 
> With the above in place, all audit logs for op=nft_register_obj have a
> predictable value in 'entries', so drop the value zeroing for them in
> audit_logread.c.
> 
> To test the skb exhaustion path, perform some bulk counter and quota
> adds in the kselftest.

This patch doesnt apply to nf.git, can you rebase it?
