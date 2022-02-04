Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4E9C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiBDFPV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:15:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49146 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiBDFPV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 00:15:21 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 00D8860198;
        Fri,  4 Feb 2022 06:15:14 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:15:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] nfqueue: enable to get skb->priority
Message-ID: <Yfy2YxiwvDLtLvTo@salvia>
References: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 09:56:13PM +0100, Nicolas Dichtel wrote:
> This info could be useful to improve traffic analysis.

Applied.
