Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0DDC3525A
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 01:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiAZBLs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:11:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46144 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiAZBLq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 20:11:46 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AE2C760254;
        Wed, 26 Jan 2022 02:08:43 +0100 (CET)
Date:   Wed, 26 Jan 2022 02:11:41 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/2] Use abort() in case of netlink_abi_error
Message-ID: <YfCfzfsZV4VzglWc@salvia>
References: <20211209182607.18550-1-crosser@average.org>
 <20211209182607.18550-2-crosser@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209182607.18550-2-crosser@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 09, 2021 at 07:26:06PM +0100, Eugene Crosser wrote:
> Library functions should not use exit(), application that uses the
> library may contain error handling path, that cannot be executed if
> library functions calls exit(). For truly fatal errors, using abort() is
> more acceptable than exit().

Applied, thanks.
