Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43DEC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 19:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C110020851
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 19:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfCHTUN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 14:20:13 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36420 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfCHTUN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 14:20:13 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h2L2R-0007jW-16; Fri, 08 Mar 2019 20:20:11 +0100
Date:   Fri, 8 Mar 2019 20:20:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] extensions: connlabel: Fallback on missing
 connlabel.conf
Message-ID: <20190308192011.ljqc4lp7ifg5d7at@breakpoint.cc>
References: <20190304150242.e66i4zj25jj2jt2q@breakpoint.cc>
 <20190304155346.29212-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304155346.29212-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> If connlabel.conf was not found, fall back to manually parsing arguments
> as plain numbers.
> 
> If nfct_labelmap_new() has failed, nfct_labelmap_get_name() segfaults.
> Therefore make sure it is not called in connlabel_get_name() if that's
> the case.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This patch supersedes patches 3-5 of this series.

Applied, thanks for updating this.
