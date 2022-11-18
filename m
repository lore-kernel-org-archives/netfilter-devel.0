Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC6FC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 14:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiKROLA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 09:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiKROK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 09:10:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6924A30550
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 06:10:58 -0800 (PST)
Date:   Fri, 18 Nov 2022 15:10:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <Y3eSbhQ+ihCNeSpE@salvia>
References: <20221117174546.21715-1-phil@nwl.cc>
 <20221117211347.GB15714@breakpoint.cc>
 <Y3dUxJZ6J4mg/KNh@orbyte.nwl.cc>
 <Y3daXmuU0Nsyeij6@salvia>
 <Y3dhhVpfoA73W3kA@orbyte.nwl.cc>
 <20221118114643.GD15714@breakpoint.cc>
 <Y3d2qqm2r8Z8Tbih@orbyte.nwl.cc>
 <Y3d4JEmztrNTbK99@salvia>
 <Y3d5eqTGTwEAa2Dq@orbyte.nwl.cc>
 <20221118133431.GE15714@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221118133431.GE15714@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 18, 2022 at 02:34:31PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This one:
> > 
> > Subject: [nft PATCH] Warn for tables with compat expressions in rules
> > Date: Wed, 12 Oct 2022 17:31:07 +0200
> > Message-Id: <20221012153107.24574-1-phil@nwl.cc>
> 
> This is:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221012153107.24574-1-phil@nwl.cc/
> 
> LGTM, no objections from me.

LGTM.
