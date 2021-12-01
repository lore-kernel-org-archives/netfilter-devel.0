Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9B3C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 16:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbhLAQwI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:52:08 -0500
Received: from mail.netfilter.org ([217.70.188.207]:54300 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhLAQwH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 11:52:07 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 33EB7605C0;
        Wed,  1 Dec 2021 17:46:27 +0100 (CET)
Date:   Wed, 1 Dec 2021 17:48:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Reduce cache overhead a bit
Message-ID: <YaenaMa1rcu5BX4U@salvia>
References: <20211201150258.18436-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211201150258.18436-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Dec 01, 2021 at 04:02:53PM +0100, Phil Sutter wrote:
> Comparing performance of various commands with equivalent iptables ones
> I noticed that nftables fetches data from kernel it doesn't need in some
> cases. For instance, listing one table was slowed down by a large other
> table.
> 
> Since there is already code to filter data added to cache, make use of
> that and craft GET requests to kernel a bit further so it returns only
> what is needed.

Using netlink to filter from kernel space is the optimal solution.

> This series is not entirely complete, e.g. objects are still fetched as
> before. It rather converts some low hanging fruits.

Only one thing: It would be good to test this on older kernels,
because IIRC some of the GET requests during the development, I would
suggest to give it a test with -stable kernels. Probably all of the
needed GET commands are already present there.

In the nftables 1.0.1 release process, I tested it with 4.9.x and
tests where running fine, the error reports were coming from missing
features.

Thanks.
