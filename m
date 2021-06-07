Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CFDC47094
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 12:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90180611AD
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 12:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFGMSF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Jun 2021 08:18:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53478 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFGMSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Jun 2021 08:18:04 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C2F0964182;
        Mon,  7 Jun 2021 14:15:00 +0200 (CEST)
Date:   Mon, 7 Jun 2021 14:16:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Paul Blakey <paulb@nvidia.com>, netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH nf-next 0/3] Control nf flow table timeouts
Message-ID: <20210607121609.GA7908@salvia>
References: <20210603121235.13804-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210603121235.13804-1-ozsh@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 03, 2021 at 03:12:32PM +0300, Oz Shlomo wrote:
> TCP and UDP connections may be offloaded from nf conntrack to nf flow table.
> Offloaded connections are aged after 30 seconds of inactivity. 
> Once aged, ownership is returned to conntrack with a hard coded tcp/udp
> pickup time of 120/30 seconds, after which the connection may be deleted. 
> 
> The current hard-coded pickup intervals may introduce a very aggressive
> aging policy. For example, offloaded tcp connections in established state
> will timeout from nf conntrack after just 150 seconds of inactivity, 
> instead of 5 days. In addition, the hard-coded 30 second offload timeout
> period can significantly increase the hardware insertion rate requirements
> in some use cases.
> 
> This patchset provides the user with the ability to configure protocol
> specific offload timeout and pickup intervals via sysctl.
> The first and second patches introduce the sysctl configuration for
> tcp and udp protocols. The last patch modifies nf flow table aging
> mechanisms to use the configured time intervals.

Series applied, thanks.
