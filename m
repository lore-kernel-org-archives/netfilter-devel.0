Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64235C4741C
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 14:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4283A2070C
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 14:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAUOgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 09:36:01 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33056 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgAUOgB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 09:36:01 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1itudL-0000WW-JZ; Tue, 21 Jan 2020 15:35:59 +0100
Date:   Tue, 21 Jan 2020 15:35:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: check for valid chain type
 pointer before dereference
Message-ID: <20200121143559.GP795@breakpoint.cc>
References: <00000000000074ed27059c33dedc@google.com>
 <20200116211109.9119-1-fw@strlen.de>
 <20200118203057.6stoe6axtyoxfcxz@salvia>
 <20200121132618.aykyybudttbxiusx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121132618.aykyybudttbxiusx@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Otherwise, if a helper function to check for the families that are
> > really supported could be another alternative. But not sure it is
> > worth?
> 
> Not worth.
> 
> Probably this patch instead? Just make sure that access to the chain
> type array is safe, no direct access to chain_type[][] anymore.
> 
> This includes the check for the default type too, since it cannot be
> assume to always have a filter chain for unsupported families.
> 
> Thanks for explaining.

LGTM, this will prbably also fix the other sytbot splat wrt.
nla_strcmp().
