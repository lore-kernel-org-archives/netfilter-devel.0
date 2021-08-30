Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C165EC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5EE60F51
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhH3ALd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 20:11:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38414 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhH3ALd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 20:11:33 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E2AB60180;
        Mon, 30 Aug 2021 02:09:41 +0200 (CEST)
Date:   Mon, 30 Aug 2021 02:10:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ryoga Saito <contact@proelbtn.com>
Cc:     netfilter-devel@vger.kernel.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 0/2] netfilter: add netfilter hooks to track
 SRv6-encapsulated flows
Message-ID: <20210830001034.GA15598@salvia>
References: <20210817083938.15051-1-contact@proelbtn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210817083938.15051-1-contact@proelbtn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 17, 2021 at 08:39:36AM +0000, Ryoga Saito wrote:
> Tunneling protocols such as VXLAN or IPIP are implemented using virtual
> network devices (vxlan0 or ipip0). Therefore, conntrack can record both
> inner flows and outer flows correctly. In contrast, SRv6 is implemented
> using lightweight tunnel infrastructure. Therefore, SRv6 packets are
> encapsulated and decapsulated without passing through virtual network
> device. Due to the following problems caused by this, conntrack can't
> record both inner flows and outer flows correctly.
> 
> First problem is caused when SRv6 packets are encapsulated. In VXLAN, at
> first, packets received are passed to nf_conntrack_in called from
> ip_rcv/ipv6_rcv. These packets are sent to virtual network device and these
> flows are confirmed in ip_output/ip6_output. However, in SRv6, at first,
> packets are passed to nf_conntrack_in, encapsulated and flows are confirmed
> in ipv6_output even if inner packets are IPv4. Therefore, IPv6 conntrack
> needs to be enabled to track IPv4 inner flow.
> 
> Second problem is caused when SRv6 packets are decapsulated. If IPv6
> conntrack is enabled, SRv6 packets are passed to nf_conntrack_in called
> from ipv6_rcv. Even if inner packets are passed to nf_conntrack_in after
> packets are decapsulated, flow aren't tracked because skb->_nfct is already
> set. Therefore, IPv6 conntrack needs to be disabled to track IPv4 flow
> when packets are decapsulated.
> 
> This patch series solves these problems and allows conntrack to record 
> inner flows correctly. It introduces netfilter hooks to srv6 lwtunnel
> and srv6local lwtunnel. It also introduces new sysctl toggle to turn on
> lightweight tunnel netfilter hooks. You can enable lwtunnel netfilter as
> following:
> 
>   sysctl net.netfilter.nf_hooks_lwtunnel=1

Applied to nf-next with a few edits. I'll post it to net-next in the
next pull request.
