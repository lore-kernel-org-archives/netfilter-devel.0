Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13A8C4743C
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 16:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF448611BD
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 16:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFUQ3o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 12:29:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55360 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhFUQ2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:23 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A9DFF64252;
        Mon, 21 Jun 2021 18:24:44 +0200 (CEST)
Date:   Mon, 21 Jun 2021 18:26:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH nf-next] docs: networking: Update connection tracking
 offload sysctl parameters
Message-ID: <20210621162605.GA3397@salvia>
References: <20210617065006.5893-1-ozsh@nvidia.com>
 <04c84d18-5707-6423-5736-a70114df0f15@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04c84d18-5707-6423-5736-a70114df0f15@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 21, 2021 at 06:14:15PM +0200, Arturo Borrero Gonzalez wrote:
> On 6/17/21 8:50 AM, Oz Shlomo wrote:
> > Document the following connection offload configuration parameters:
> > - nf_flowtable_tcp_timeout
> > - nf_flowtable_tcp_pickup
> > - nf_flowtable_udp_timeout
> > - nf_flowtable_udp_pickup
> > 
> > Signed-off-by: Oz Shlomo<ozsh@nvidia.com>
> 
> Sorry for the late feedback.
> 
> In my experience the kernel docs have rather poor documents for netfilter
> sysctl parameters. I often find myself reading the source code for a deeper
> understanding of what is going on.
> 
> The docs included in this patch are too short in my opinion, example:
> 
> +nf_flowtable_tcp_pickup - INTEGER (seconds)
> +        default 120
> +
> +        TCP connection timeout after being aged from nf flow table offload.
> 
> 
> Here, having an example of the sequence of events going on with the
> conntrack entry and how this sysctl key affects it would be great. Some
> explanation of the behavior that may be observed when tuning this value
> would be nice as well.
> 
> Given the patch was merged already, you can feel free to ignore this anyway :-)

I think I can extend the flowtable documentation to include this
information:

https://www.kernel.org/doc/html/latest/networking/nf_flowtable.html

to refer to this new sysctl knobs too.

If you think something else in the big picture, please, let me know
I'll be glad to extend it.

Thanks!
