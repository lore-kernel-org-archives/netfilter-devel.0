Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B938BC432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 23:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95C8720708
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 23:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKTX0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 18:26:21 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50654 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfKTX0V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 18:26:21 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iXZMX-0000JT-SQ; Thu, 21 Nov 2019 00:26:18 +0100
Date:   Thu, 21 Nov 2019 00:26:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <20191120232617.GH20235@breakpoint.cc>
References: <20191120230942.GA12786@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120230942.GA12786@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> Deprecated nfq_set_queue_flags documents flag NFQA_CFG_F_FAIL_OPEN for kernel to
> accept packets if the kernel queue gets full.
> 
> Does this still work with libmnl?

Yes.
> I'm thinking we need a new "Library Setup
> [CURRENT]" section to document available flags (including e.g. NFQA_CFG_F_GSO
> that examples/nf-queue.c uses).

Makes sense, thanks.

> Maybe we need Attribute helper functions as well? (documentation *and* new
> code).

If you think it makes it easier, sure, why not.
But it would be something like this:

void nfq_nlmsg_cfg_put_flags(struct nlmsghdr *nlh, uint32_t flags)
{
        mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
        mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
}

I'm not sure that warrants a library helper.
