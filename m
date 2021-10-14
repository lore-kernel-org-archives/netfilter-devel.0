Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DB2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E67561073
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 21:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJNVEj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 17:04:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47174 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhJNVEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 17:04:38 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AB72863F25;
        Thu, 14 Oct 2021 23:00:55 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:02:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: remove obsolete hook wrappers
Message-ID: <YWia5Qd69YiHea6P@salvia>
References: <20211011151514.6580-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011151514.6580-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 11, 2021 at 05:15:09PM +0200, Florian Westphal wrote:
> An earlier series, starting with
> commit a4aeafa28cf706f65f ("netfilter: xt_nat: pass table to hookfn"),
> converted the x_tables table implementations to store the hook blob in
> the ->priv pointer that gets passed to the hook function.
> 
> Before this, the blobs were stored in struct net, so each table
> required its own wrapper to fetch the correct table blob.
> 
> Nowadays, allmost all hook functions in x_table land just call the hook
> evaluation loop.
> 
> This series converts the table evaluation loop so it can be used directly,
> then removes most of the wrappers.

Series applied, thanks
