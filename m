Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DB1C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 00:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbhLHAbs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:31:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38936 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHAbs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 19:31:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1FD2C605BA;
        Wed,  8 Dec 2021 01:25:55 +0100 (CET)
Date:   Wed, 8 Dec 2021 01:28:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: nat: force port remap to prevent shadowing
 well-known ports
Message-ID: <Ya/8HfhxpspXzE01@salvia>
References: <20211129144218.2677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211129144218.2677-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 03:42:18PM +0100, Florian Westphal wrote:
> If destination port is above 32k and source port below 16k
> assume this might cause 'port shadowing' where a 'new' inbound
> connection matches an existing one, e.g.
> 
> inbound X:41234 -> Y:53 matches existing conntrack entry
>         Z:53 -> X:4123, where Z got natted to X.
> 
> In this case, new packet is natted to Z:53 which is likely
> unwanted.
> 
> We could avoid the rewrite for connections that are not being forwarded,
> but get_unique_tuple() and the callers don't propagate the required hook
> information for this.

Probably you can scratch a bit to store in the struct nf_conn object
if this is locally generated flows?

Thanks
