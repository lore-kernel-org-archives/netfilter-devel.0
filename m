Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A16BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 09:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiAKJmd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 04:42:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45810 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiAKJmb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 04:42:31 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9117F605C6;
        Tue, 11 Jan 2022 10:39:38 +0100 (CET)
Date:   Tue, 11 Jan 2022 10:42:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_netbios_ns: fix helper module
 alias
Message-ID: <Yd1RANMSe6qdMMzL@salvia>
References: <20220107145138.4818-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220107145138.4818-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 07, 2022 at 03:51:38PM +0100, Florian Westphal wrote:
> The helper gets registered as 'netbios-ns', not netbios_ns.
> Intentionally not adding a fixes-tag because i don't want this to go to
> stable. This wasn't noticed for a very long time so no so no need to risk
> regressions.

Applied, thanks
