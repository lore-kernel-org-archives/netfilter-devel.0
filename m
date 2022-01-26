Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AF2C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 23:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiAZXAo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:00:44 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58382 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiAZXAn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 18:00:43 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BD87460239;
        Wed, 26 Jan 2022 23:57:38 +0100 (CET)
Date:   Thu, 27 Jan 2022 00:00:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Remove flowtable relics
Message-ID: <YfHSltpmDuibUSx2@salvia>
References: <20220123125717.2658676-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220123125717.2658676-1-geert@linux-m68k.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 23, 2022 at 01:57:17PM +0100, Geert Uytterhoeven wrote:
> NF_FLOW_TABLE_IPV4 and NF_FLOW_TABLE_IPV6 are invisble, selected by
> nothing (so they can no longer be enabled), and their last real users
> have been removed (nf_flow_table_ipv6.c is empty).
> 
> Clean up the leftovers.

Applied, thanks
