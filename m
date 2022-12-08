Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806B3C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 12:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLHMGT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 07:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiLHMGS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 07:06:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D3DF88B49;
        Thu,  8 Dec 2022 04:06:17 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:06:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: Re: [PATCHv7 0/6] ipvs: Use kthreads for stats
Message-ID: <Y5HTM6jY/ZRw+ar0@salvia>
References: <20221122164604.66621-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221122164604.66621-1-ja@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 22, 2022 at 06:45:58PM +0200, Julian Anastasov wrote:
> 	Hello,
> 
> 	This patchset implements stats estimation in kthread context.
> It replaces the code that runs on single CPU in timer context every
> 2 seconds and causing latency splats as shown in reports [1], [2], [3].
> The solution targets setups with thousands of IPVS services, destinations
> and multi-CPU boxes.

Series applied to nf-next, thanks.
