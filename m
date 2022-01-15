Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7B3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 17:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiAOR3t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 12:29:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57058 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiAOR3s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 12:29:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1F688605C3
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 18:26:54 +0100 (CET)
Date:   Sat, 15 Jan 2022 18:29:44 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables,v2 0/7] ruleset optimization infrastructure
Message-ID: <YeMEiN6rb8dU7VEi@salvia>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 02, 2022 at 11:14:45PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds a new -o/--optimize option to enable ruleset
> optimization.

For the record, I have pushed out these.
