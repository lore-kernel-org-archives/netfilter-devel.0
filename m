Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B7EC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE66E60F22
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhJ0WzW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:55:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49400 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhJ0WzW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 18:55:22 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EBE2663F21;
        Thu, 28 Oct 2021 00:51:02 +0200 (CEST)
Date:   Thu, 28 Oct 2021 00:52:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support netdev egress hook
Message-ID: <YXnYPnrm/gUf0a/6@salvia>
References: <20211027101715.47905-1-pablo@netfilter.org>
 <20211027121442.GA20375@wunner.de>
 <YXlUIuoRaI8WmbZT@salvia>
 <20211027221301.GA5956@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211027221301.GA5956@wunner.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 28, 2021 at 12:13:01AM +0200, Lukas Wunner wrote:
> On Wed, Oct 27, 2021 at 03:29:06PM +0200, Pablo Neira Ayuso wrote:
> > I'll apply these two patches if you are fine with their state.
> 
> I'm fine with them.  Do you want me to resend them as patches
> (instead of as attachments)?

No need to.

> When running tests I noted an oddity:
> 
> tests/shell/testcases/0031set_timeout_size_0 fails because
> 1d2h3m4s10ms is reported as 1d2h3m4s8ms, so 2 msec less.
> Might be caused by the kernel I tested against (v5.13.12),
> doesn't seem related to my patches, but odd nevertheless.

Likely related to:

commit c9c5b5f621c37d17140dac682d211825ef321093
Author: Phil Sutter <phil@nwl.cc>
Date:   Mon Jul 26 15:27:32 2021 +0200

    tests: shell: Fix bogus testsuite failure with 100Hz
