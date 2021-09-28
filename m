Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCBEC43217
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 11:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7548861131
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 11:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240328AbhI1LHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:07:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57268 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbhI1LHC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 07:07:02 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6642163EA7;
        Tue, 28 Sep 2021 13:03:57 +0200 (CEST)
Date:   Tue, 28 Sep 2021 13:05:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: fix boot failure with
 nf_conntrack.enable_hooks=1
Message-ID: <YVL27Ems+M8uhS5/@salvia>
References: <20210923144434.22531-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210923144434.22531-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 23, 2021 at 04:44:34PM +0200, Florian Westphal wrote:
> This is a revert of
> 7b1957b049 ("netfilter: nf_defrag_ipv4: use net_generic infra")
> and a partial revert of
> 8b0adbe3e3 ("netfilter: nf_defrag_ipv6: use net_generic infra").
> 
> If conntrack is builtin and kernel is booted with:
> nf_conntrack.enable_hooks=1
> 
> .... kernel will fail to boot due to a NULL deref in
> nf_defrag_ipv4_enable(): Its called before the ipv4 defrag initcall is
> made, so net_generic() returns NULL.
> 
> To resolve this, move the user refcount back to struct net so calls
> to those functions are possible even before their initcalls have run.

Applied to nf, thanks.
