Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF32C61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 17:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCIRn5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 12:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCIRnu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 12:43:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBFD75DCB0
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2023 09:43:26 -0800 (PST)
Date:   Thu, 9 Mar 2023 18:43:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] xt: Fix fallback printing for extensions matching
 keywords
Message-ID: <ZAoauxzjCq7jYevG@salvia>
References: <20230309134350.9803-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230309134350.9803-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 09, 2023 at 02:43:50PM +0100, Phil Sutter wrote:
> Yet another Bison workaround: Instead of the fancy error message, an
> incomprehensible syntax error is emitted:
> 
> | # iptables-nft -A FORWARD -p tcp -m osf --genre linux
> | # nft list ruleset | nft -f -
> | # Warning: table ip filter is managed by iptables-nft, do not touch!
> | /dev/stdin:4:29-31: Error: syntax error, unexpected osf, expecting string
> | 		meta l4proto tcp xt match osf counter packets 0 bytes 0
> | 		                          ^^^
> 
> Avoid this by quoting the extension name when printing:
> 
> | # nft list ruleset | sudo ./src/nft -f -
> | # Warning: table ip filter is managed by iptables-nft, do not touch!
> | /dev/stdin:4:20-33: Error: unsupported xtables compat expression, use iptables-nft with this ruleset
> | 		meta l4proto tcp xt match "osf" counter packets 0 bytes 0
> | 		                 ^^^^^^^^^^^^^^


LGTM.
