Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28539C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Dec 2021 00:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbhLWACm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 19:02:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41660 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLWACl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 19:02:41 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C47E362BD8;
        Thu, 23 Dec 2021 01:00:05 +0100 (CET)
Date:   Thu, 23 Dec 2021 01:02:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 0/2] nat: force port remap to prevent
 shadowing well-known ports
Message-ID: <YcO8nJ4ELrPv70H0@salvia>
References: <20211217102957.2999-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211217102957.2999-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 17, 2021 at 11:29:55AM +0100, Florian Westphal wrote:
> Hi,
> 
> This is a resend of the port remap change with auto-exception for
> locally originating connections.
> 
> This is done by adding a bit in nf_conn for LOCAL_OUT tracked entries.

Series applied, thanks
