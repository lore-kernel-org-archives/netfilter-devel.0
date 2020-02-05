Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85487C35254
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 11:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629BE21741
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 11:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgBELlO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 06:41:14 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39396 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728284AbgBELlO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 06:41:14 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1izJ3Q-0001gE-00; Wed, 05 Feb 2020 12:41:12 +0100
Date:   Wed, 5 Feb 2020 12:41:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel <tech@tootai.net>
Cc:     Netfilter list <netfilter-devel@vger.kernel.org>
Subject: Re: NFT - delete rules per interface
Message-ID: <20200205114111.GD26952@breakpoint.cc>
References: <1292e1cd-d593-b1a5-2850-3ae18bd54a6c@tootai.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292e1cd-d593-b1a5-2850-3ae18bd54a6c@tootai.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel <tech@tootai.net> wrote:
> Hello,
> 
> is there an easy way to delete rules/set/maps/... for a specific interface ?

Can you elaborate?  With exception of netdev interface, none of these
are per interface.

