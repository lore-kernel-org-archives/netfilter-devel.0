Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED53C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAB2610CB
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhJNVLb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 17:11:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47212 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhJNVLa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 17:11:30 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 40EBF63F25;
        Thu, 14 Oct 2021 23:07:46 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:09:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv2 nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Message-ID: <YWicgKOG51NLyyi7@salvia>
References: <6ee8ec63c78925fadf0304c8a55cac73824234af.1634041093.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ee8ec63c78925fadf0304c8a55cac73824234af.1634041093.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 12, 2021 at 08:18:13AM -0400, Xin Long wrote:
> In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
> only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
> The access by ((const struct rt0_hdr *)rh)->reserved will overflow
> the buffer. So this access should be moved below the 2nd call to
> skb_header_pointer().
> 
> Besides, after the 2nd skb_header_pointer(), its return value should
> also be checked, othersize, *rp may cause null-pointer-ref.

Applied, thanks
