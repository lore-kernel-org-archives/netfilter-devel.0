Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A5CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Dec 2021 23:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345474AbhLVXcU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 18:32:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41592 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbhLVXcU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 18:32:20 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E4ADA607C4;
        Thu, 23 Dec 2021 00:29:43 +0100 (CET)
Date:   Thu, 23 Dec 2021 00:32:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] parser: allow quoted string in
 flowtable_expr_member
Message-ID: <YcO1ftfiPxwZSRT+@salvia>
References: <20211221104025.2362302-1-stijn@linux-ipv6.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211221104025.2362302-1-stijn@linux-ipv6.be>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 21, 2021 at 12:40:25PM +0200, Stijn Tintel wrote:
> Devices with interface names starting with a digit can not be configured
> in flowtables. Trying to do so throws the following error:
> 
> Error: syntax error, unexpected number, expecting comma or '}'
> devices = { eth0, 6in4-wan6 };
> 
> This is however a perfectly valid interface name. Solve the issue by
> allowing the use of quoted strings.

Applied, thanks
