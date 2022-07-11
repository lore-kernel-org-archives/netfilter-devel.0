Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7376C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiGKOlI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGKOlH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:41:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A5EDB92;
        Mon, 11 Jul 2022 07:41:06 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:41:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com
Subject: Re: [PATCH] netfilter: Fix spelling mistake
Message-ID: <Ysw2f6FOuXIPQIxY@salvia>
References: <20220623080141.7567-1-jiaming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623080141.7567-1-jiaming@nfschina.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 04:01:41PM +0800, Zhang Jiaming wrote:
> Change 'succesful' to 'successful'.
> Change 'transation' to 'transaction'.

Applied to nf-next
