Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D21C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 14:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiBIOLv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 09:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiBIOLt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 09:11:49 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57ED6C050CD7
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 06:11:46 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61B86601C5;
        Wed,  9 Feb 2022 15:11:34 +0100 (CET)
Date:   Wed, 9 Feb 2022 15:11:42 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: iptables-test: Support variant deviation
Message-ID: <YgPLnk/AFfRhOADQ@salvia>
References: <20220204175520.29755-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204175520.29755-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 04, 2022 at 06:55:20PM +0100, Phil Sutter wrote:
> Some test results are not consistent between variants:
> 
> * CLUSTERIP is not supported with nft_compat, so all related tests fail
>   with iptables-nft.
> * iptables-legacy mandates TCPMSS be combined with SYN flag match,
>   iptables-nft does not care. (Or precisely, xt_TCPMSS.ko can't validate
>   match presence.)
> 
> Avoid the expected failures by allowing "NFT" and "LGC" outcomes in
> addition to "OK" and "FAIL". They specify the variant with which given
> test should pass.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  extensions/libipt_CLUSTERIP.t | 4 ++--
>  extensions/libxt_TCPMSS.t     | 2 +-
>  iptables-test.py              | 7 +++++--
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/extensions/libipt_CLUSTERIP.t b/extensions/libipt_CLUSTERIP.t
> index 5af555e005c1d..d3a2d6cbb1b2e 100644
> --- a/extensions/libipt_CLUSTERIP.t
> +++ b/extensions/libipt_CLUSTERIP.t
> @@ -1,4 +1,4 @@
>  :INPUT
>  -d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 0 --hash-init 1;=;FAIL
> --d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK

Could you add a new semicolon to the test line instead?

--d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK;LEGACY

> --d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;OK
> +-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;LGC
> +-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;LGC

Thanks
