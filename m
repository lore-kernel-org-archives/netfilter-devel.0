Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017DAC28EB4
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 16:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA13E20652
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 16:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfFFQ3d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 12:29:33 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52188 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbfFFQ3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 12:29:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYvGc-0002Ug-H2; Thu, 06 Jun 2019 18:29:30 +0200
Date:   Thu, 6 Jun 2019 18:29:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipv6: nf_defrag: accept duplicate
 fragments again
Message-ID: <20190606162930.yxcuk3nsrath7qxq@breakpoint.cc>
References: <e8f3e725c5546df221c4aeec340b6bb73631145e.1559836971.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f3e725c5546df221c4aeec340b6bb73631145e.1559836971.git.gnault@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:
> When fixing the skb leak introduced by the conversion to rbtree, I
> forgot about the special case of duplicate fragments. The condition
> under the 'insert_error' label isn't effective anymore as
> nf_ct_frg6_gather() doesn't override the returned value anymore. So
> duplicate fragments now get NF_DROP verdict.
> 
> To accept duplicate fragments again, handle them specially as soon as
> inet_frag_queue_insert() reports them. Return -EINPROGRESS which will
> translate to NF_STOLEN verdict, like any accepted fragment. However,
> such packets don't carry any new information and aren't queued, so we
> just drop them immediately.

Why is this patch needed?

Whats the difference between

NF_DROP and kfree_skb+NF_STOLEN?

AFAICS this patch isn't needed, as nothing is broken, what am I missing?
