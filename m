Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0BAC76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB364218A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfGVMrm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:47:42 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53228 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726895AbfGVMrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:47:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpXjA-0002dF-K2; Mon, 22 Jul 2019 14:47:40 +0200
Date:   Mon, 22 Jul 2019 14:47:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] evaluate: missing location for chain nested in table
 definition
Message-ID: <20190722124740.ffu4jmcz3ivukl2w@breakpoint.cc>
References: <20190722115522.31726-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722115522.31726-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> error reporting may crash because location is unset.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This supersedes your patch 2/3. Regarding 1/3, I think it should be good
> to assume location must be always set, so BUG() is probably a good idea
> from erec_print() if unset.

I can confirm this works, instead of crash one now gets
crash.nft:7:13-16: Error: No such file or directory
      chain test {
            ^^^^
