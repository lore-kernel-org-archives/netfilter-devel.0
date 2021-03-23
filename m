Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C65C433C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Mar 2021 21:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A37619CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Mar 2021 21:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhCWVhE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 17:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhCWVgf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 17:36:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BD1C061574;
        Tue, 23 Mar 2021 14:36:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lOohT-0007hU-Nr; Tue, 23 Mar 2021 22:36:31 +0100
Date:   Tue, 23 Mar 2021 22:36:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v3] audit: log nftables configuration change events once
 per table
Message-ID: <20210323213631.GA27244@breakpoint.cc>
References: <3d15fa1f0c54335f9258d90ea0d11050e780ba70.1616529248.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d15fa1f0c54335f9258d90ea0d11050e780ba70.1616529248.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);
>  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
>  	nf_tables_commit_release(net);
>  
> +	nf_tables_commit_audit_log(&adl, net->nft.base_seq);

This meeds to be before nf_tables_commit_release() call, afaics this function
dereferences data structures that might be free'd already here.
