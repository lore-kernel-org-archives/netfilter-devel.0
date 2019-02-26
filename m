Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8F2C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 06:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584882147C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 06:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfBZGbt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 01:31:49 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725879AbfBZGbt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 01:31:49 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gyWHJ-0001hd-7E; Tue, 26 Feb 2019 07:31:45 +0100
Date:   Tue, 26 Feb 2019 07:31:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?Q?H=5D=5Bnf-next?= =?utf-8?Q?=5D?= netfilter: replace modulo
 operation with bitwise AND
Message-ID: <20190226063145.i4ctlywl47lfj5d5@breakpoint.cc>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
 <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
 <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
 <20190225115404.lul4qhfailu5u4yx@breakpoint.cc>
 <9563bbe86d9d4c719cfedafc8ded7ff8@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9563bbe86d9d4c719cfedafc8ded7ff8@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Li,Rongqing <lirongqing@baidu.com> wrote:
> I think this patches maybe doing two thing:
> 
> 1. make codes not depend on compiler optimization
> 2. remind to not change CONNTRACK_LOCKS to a value which is not power of 2

You could add a BUILD_BUG_ON_NOT_POWER_OF_2() check for that.
