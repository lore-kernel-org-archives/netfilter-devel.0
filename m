Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFB3C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 00:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbhLHA32 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:29:28 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38884 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHA31 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 19:29:27 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 40595605BA;
        Wed,  8 Dec 2021 01:23:33 +0100 (CET)
Date:   Wed, 8 Dec 2021 01:25:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix AVX2 MAC address match, add
 test
Message-ID: <Ya/7j00v4I2omwqt@salvia>
References: <cover.1637976889.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1637976889.git.sbrivio@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 27, 2021 at 11:33:36AM +0100, Stefano Brivio wrote:
> Patch 1/2 fixes the issue reported by Nikita where a MAC address
> wouldn't match if given as first field of a set, and patch 2/2 adds
> the corresponding test.

Series applied, thanks
