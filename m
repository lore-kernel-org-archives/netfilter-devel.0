Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E799FC433C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7AD619E9
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhCXBkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:40:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60928 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhCXBiO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:38:14 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E2BF762BEA;
        Wed, 24 Mar 2021 02:38:04 +0100 (CET)
Date:   Wed, 24 Mar 2021 02:38:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <20210324013810.GA5861@salvia>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia>
 <YFjdb7DveNOolSTr@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFjdb7DveNOolSTr@horizon.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Marcelo,

On Mon, Mar 22, 2021 at 03:09:51PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
[...]
> > Or probably make the cookie unique is sufficient? The cookie refers to
> > the memory address but memory can be recycled very quickly. If the
> > cookie helps to catch the reorder scenario, then the conntrack id
> > could be used instead of the memory address as cookie.
> 
> Something like this, if I got the idea right, would be even better. If
> the entry actually expired before it had a chance of being offloaded,
> there is no point in offloading it to then just remove it.

It would be interesting to explore this idea you describe. Maybe a
flag can be set on stale objects, or simply remove the stale object
from the offload queue. So I guess it should be possible to recover
control on the list of pending requests as a batch that is passed
through one single queue_work call.
