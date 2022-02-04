Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1361DC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 04:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiBDEld (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:41:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49006 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBDEld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 23:41:33 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A8EEE60195;
        Fri,  4 Feb 2022 05:41:27 +0100 (CET)
Date:   Fri, 4 Feb 2022 05:41:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_payload: don't allow th access for
 fragments
Message-ID: <YfyueZomR83YEK63@salvia>
References: <20220129161323.173737-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220129161323.173737-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 29, 2022 at 05:13:23PM +0100, Florian Westphal wrote:
> Loads relative to ->thoff naturally expect that this points to the
> transport header, but this is only true if pkt->fragoff == 0.
> 
> This has little effect for rulesets with connection tracking/nat because
> these enable ip defra. For other rulesets this prevents false matches.

Also applied
