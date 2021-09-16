Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779EFC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 599DC60EE5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhIPJ22 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 05:28:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58668 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhIPJ21 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 05:28:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 24F636008D;
        Thu, 16 Sep 2021 11:25:52 +0200 (CEST)
Date:   Thu, 16 Sep 2021 11:27:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Zatloukal <slezi2@pvfree.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: list vmap counter errot
Message-ID: <20210916092702.GA31336@salvia>
References: <ec914466-169b-b146-c216-e1faf1159068@pvfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ec914466-169b-b146-c216-e1faf1159068@pvfree.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Sep 16, 2021 at 10:38:03AM +0200, Martin Zatloukal wrote:
> 
> hi. i am trying nftables for our igw and i ran into a problem.
> 
> add map ip filter forwport { type ipv4_addr . inet_proto . inet_service:
> verdict; flags interval; counter;  }
> 
> add rule ip filter FORWARD iifname $INET_IFACE ip daddr . ip protocol  . th
> dport vmap @forwport counter
> 
> if I enter
> 
> nft list ruleset
> 
> then cli send : Unauthorized Memory Access (SIGSEGV)
> 
> 
> dmesg
> 
> [ 1056.857354] nft[1069]: segfault at 10 ip 00007f44edde176d sp
> 00007ffc2cdb8fa0 error 4 in libnftables.so.1.1.0[7f44eddd8000+62000]
> 
> [ 1056.857362] Code: 89 68 10 48 89 50 38 48 83 c4 08 5b 5d c3 66 66 2e 0f
> 1f 84 00 00 00 00 00 0f 1f 40 00 48 85 ff 74 23 55 48 8b 47 10 48 89 fd <48>
> 8b 40 10 48 85 c0 74 02 ff d0 48 89 ef 5d e9 2f a4 02 00 0f 1f
> 
> if map not use flags counter,is listing ok
> 
> debian 11
> 
> libnftables1_1.0.0-1_amd64.deb
> nftables_1.0.0-1_amd64.deb

I cannot reproduce this here, valgrind and ASAN outputs are perfectly
clean?

Could you post you ldd /usr/sbin/nft output? Could you run 'nft list
ruleset' inside valgrind?  Or there is any rule that is missing in
your setup to reproduce what you are observing?
