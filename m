Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5438C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Nov 2021 11:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB6E63210
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Nov 2021 11:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhKOLGN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 06:06:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:34604 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbhKOLFt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 06:05:49 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6B473605C5;
        Mon, 15 Nov 2021 12:00:48 +0100 (CET)
Date:   Mon, 15 Nov 2021 12:02:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH nf] selftests: nft_nat: switch port shadow test cases to
 socat
Message-ID: <YZI+WSnUwaGYZOgK@salvia>
References: <20211111172330.31086-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211111172330.31086-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 11, 2021 at 06:23:30PM +0100, Florian Westphal wrote:
> There are now at least three distinct flavours of netcat/nc tool:
> 'original' version, one version ported from openbsd and nmap-ncat.
> 
> The script only works with original because it sets SOREUSEPORT option.
> 
> Other nc versions return 'port already in use' error and port shadow test fails:
> 
> PASS: inet IPv6 redirection for ns2-hMHcaRvx
> nc: bind failed: Address already in use
> ERROR: portshadow test default: got reply from "ROUTER", not CLIENT as intended
> 
> Switch to socat instead.

Applied.
