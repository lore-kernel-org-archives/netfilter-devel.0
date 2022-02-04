Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19D9C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbiBDFQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:16:31 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49164 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiBDFQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 00:16:30 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0296660198;
        Fri,  4 Feb 2022 06:16:23 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:16:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] nfqueue: enable to get skb->priority
Message-ID: <Yfy2qiiYEeWLe8sI@salvia>
References: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
 <Yfy2YxiwvDLtLvTo@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yfy2YxiwvDLtLvTo@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 04, 2022 at 06:15:20AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 17, 2022 at 09:56:13PM +0100, Nicolas Dichtel wrote:
> > This info could be useful to improve traffic analysis.
> 
> Applied.

Maybe allow to update this skbuff field from the verdict path too?
I don't remember any read-only field like this in nfqueue.
