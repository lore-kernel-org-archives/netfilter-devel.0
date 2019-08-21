Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971BEC3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 15:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7079E22DA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 15:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfHUPwG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:52:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41222 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfHUPwG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 11:52:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0Su4-0005DO-Vj; Wed, 21 Aug 2019 17:52:05 +0200
Date:   Wed, 21 Aug 2019 17:52:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Todd Seidelmann <tseidelmann@linode.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_physdev: Fix spurious error message in
 physdev_mt_check
Message-ID: <20190821155204.GC13057@breakpoint.cc>
References: <88b305fb-ebb9-5e81-f8ef-55a18609c5fc@linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88b305fb-ebb9-5e81-f8ef-55a18609c5fc@linode.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Todd Seidelmann <tseidelmann@linode.com> wrote:
> Simplify the check in physdev_mt_check() to emit an error message
> only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
> This avoids cluttering up the log with errors against valid rules.
> 
> For large/heavily modified rulesets, current behavior can quickly
> overwhelm the ring buffer, because this function gets called on
> every change, regardless of the rule that was changed.

Agreed, we've had this notice long enough, better to only
print it when we reject the rule.

Acked-by: Florian Westphal <fw@strlen.de>
