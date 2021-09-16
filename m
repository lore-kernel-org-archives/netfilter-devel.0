Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81A9C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 12:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBDA661242
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 12:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhIPMC0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:02:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59216 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbhIPMC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 08:02:26 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 43606606B6;
        Thu, 16 Sep 2021 13:59:51 +0200 (CEST)
Date:   Thu, 16 Sep 2021 14:01:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Zatloukal <slezi2@pvfree.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: list vmap counter errot
Message-ID: <20210916120100.GA21799@salvia>
References: <ec914466-169b-b146-c216-e1faf1159068@pvfree.net>
 <20210916092702.GA31336@salvia>
 <d02072df-d5e5-b76d-0003-0a6ef62f5d00@pvfree.net>
 <20210916120005.GB11941@salvia>
 <20210916120027.GA21782@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210916120027.GA21782@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 16, 2021 at 01:05:03PM +0200, Martin Zatloukal wrote:
[...]
> root@igw-test:~# cat /etc/firewall/test
> 
> #!/sbin/nft -f
> 
> flush ruleset
> 
> add table ip filter
> add chain ip filter FORWARD { type filter hook forward priority 0; policy
> drop; }
> 
> add map ip filter forwport { type ipv4_addr . inet_proto . inet_service:
> verdict; flags interval; counter;  }
> add rule ip filter FORWARD iifname enp0s8 ip daddr . ip protocol  . th dport
> vmap @forwport counter
> 
> add element ip filter forwport { 10.133.89.138 . tcp . 8081: accept }

Thanks, this repro is useful. I managed to reproduce it.

Fix it here:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210916115838.21724-1-pablo@netfilter.org/

Thanks for reporting.
