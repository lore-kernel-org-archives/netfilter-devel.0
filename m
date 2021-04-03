Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E4FC433ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 18:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A636124C
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 18:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhDCSDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Apr 2021 14:03:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57020 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhDCSDs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Apr 2021 14:03:48 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BD56363E3E;
        Sat,  3 Apr 2021 20:03:25 +0200 (CEST)
Date:   Sat, 3 Apr 2021 20:03:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] files: move example files away from /etc
Message-ID: <20210403180339.GA24128@salvia>
References: <20210330144653.25119-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330144653.25119-1-jengelh@inai.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 30, 2021 at 04:46:53PM +0200, Jan Engelhardt wrote:
> As per file-hierarchy(5), /etc is for "system-specific configuration", not
> "vendor-supplied default configuration files".
> 
> Moreover, the comments in all-in-one.nft say it is an example, and so,
> not a vendor config either.
> 
> Move it out of /etc.

Applied, thanks.
