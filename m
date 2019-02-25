Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41958C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A06213A2
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfBYL0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:26:52 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36756 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfBYL0w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 06:26:52 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gyEPI-0002vf-Na; Mon, 25 Feb 2019 12:26:48 +0100
Date:   Mon, 25 Feb 2019 12:26:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH][nf-next] netfilter: replace modulo operation with
 bitwise AND
Message-ID: <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Li RongQing <lirongqing@baidu.com> wrote:
> CONNTRACK_LOCKS is 1024 and power of 2, so modulo operations
> can be replaced with AND (CONNTRACK_LOCKS - 1)
> 
> and bitwise AND operation is quicker than module operation

Uh.  What kind of compiler doesn't figure that out?!

I would prefer to keep it as-is and let compiler do the optimization.
