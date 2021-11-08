Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C8FC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF7161242
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhKHK3J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:29:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46770 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237552AbhKHK2s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:28:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2A3166063C;
        Mon,  8 Nov 2021 11:24:05 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:25:59 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: extend nfqueue tests to cover
 vrf device
Message-ID: <YYj7N5Hppz3I2mAp@salvia>
References: <20211020162537.11361-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211020162537.11361-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 20, 2021 at 06:25:37PM +0200, Florian Westphal wrote:
> VRF device calls the output/postrouting hooks so packet should be seeon
> with oifname tvrf and once with eth0.

Applied, thanks.
