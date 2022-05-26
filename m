Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E64C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 20:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiEZUs6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348865AbiEZUs5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 16:48:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19388E64DF
        for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2022 13:48:56 -0700 (PDT)
Date:   Thu, 26 May 2022 22:48:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_limit: Clone packet limits' cost value
Message-ID: <Yo/ntUD4NIWTxqnE@salvia>
References: <20220524125001.25881-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220524125001.25881-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 24, 2022 at 02:50:01PM +0200, Phil Sutter wrote:
> When cloning a packet-based limit expression, copy the cost value as
> well. Otherwise the new limit is not functional anymore.

Applied, thanks
