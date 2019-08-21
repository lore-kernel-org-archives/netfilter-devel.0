Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D87C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A90B22CE3
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfHULLH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:11:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39866 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfHULLH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 07:11:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0OW9-0003Yx-Gj; Wed, 21 Aug 2019 13:11:05 +0200
Date:   Wed, 21 Aug 2019 13:11:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 nf-next] netfilter: nf_tables: Introduce stateful
 object update operation
Message-ID: <20190821111105.GA13057@breakpoint.cc>
References: <20190821094420.866-1-ffmancera@riseup.net>
 <20190821100905.GX2588@breakpoint.cc>
 <17f338ec-fe44-3ba7-3115-4b5f16d93ccf@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17f338ec-fe44-3ba7-3115-4b5f16d93ccf@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> How is that argument going to be used? If 'commit' is false we should
> just check that values are fine but not update them?

Yes, thats the idea.

> Yes, I agree on updating the object in the commit phase. But I am not
> sure about how I should place it on 'trans'. Any hints? Thanks :-)

Can you place a pointer to the tb array on the trans object?

Another possibility is to have ->update return a kmalloced blob
that contains ready-to-use binary data, so depending on the 'bool
commit' the update hook would expect either tb[] (for validation)
or a backend-maintained struct with the to-update values.

In the quota case it would be a struct containing the u64 values.

> I am also writing some userspace shell tests.

Thats good, thanks Fernando!
