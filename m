Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6A9C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 22:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C1B64E38
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 22:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBKWKP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 17:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhBKWKO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 17:10:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC17BC061574;
        Thu, 11 Feb 2021 14:09:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lAK9S-0005k6-N8; Thu, 11 Feb 2021 23:09:30 +0100
Date:   Thu, 11 Feb 2021 23:09:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, Phil Sutter <phil@nwl.cc>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210211220930.GC2766@breakpoint.cc>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211202628.GP2015948@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> > > I personally would notify once per transaction. This is easy and quick.
> 
> This was the goal.  iptables was atomic.  nftables appears to no longer
> be so.  If I have this wrong, please show how that works.

nftables transactions are atomic, either the entire batch takes effect or not
at all.

The audit_log_nfcfg() calls got added to the the nft monitor infra which
is designed to allow userspace to follow the entire content of the
transaction log.

So, if its just a 'something was changed' event that is needed all of
them can be removed. ATM the audit_log_nfcfg() looks like this:

        /* step 3. Start new generation, rules_gen_X now in use. */
        net->nft.gencursor = nft_gencursor_next(net);

        list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
                switch (trans->msg_type) {
                case NFT_MSG_NEWTABLE:
			audit_log_nfcfg();
			...
		case NFT_MSG_...
			audit_log_nfcfg();
	..
	       	}

which gives an audit_log for every single change in the batch.

So, if just a summary is needed a single audit_log_nfcfg()
after 'step 3' and outside of the list_for_each_entry_safe() is all
that is needed.

If a summary is wanted as well one could fe. count the number of
transaction types in the batch, e.g. table adds, chain adds, rule
adds etc. and then log a summary count instead.
