Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500D4C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 10:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B032133F
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 10:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfE0KBx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 06:01:53 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34616 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfE0KBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 06:01:53 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hVCS0-0004ss-1A; Mon, 27 May 2019 12:01:52 +0200
Date:   Mon, 27 May 2019 12:01:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nft] src: add cache_is_complete() and cache_is_updated()
Message-ID: <20190527100151.GU31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, eric@garver.life
References: <20190524184618.5315-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524184618.5315-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 24, 2019 at 08:46:18PM +0200, Pablo Neira Ayuso wrote:
> Just a few functions to help clarify cache update logic.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
