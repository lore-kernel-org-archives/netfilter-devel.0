Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAE5C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 17:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D996121F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbhJGRl2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 13:41:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60114 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242882AbhJGRlZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 13:41:25 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C1C463EE1;
        Thu,  7 Oct 2021 19:37:58 +0200 (CEST)
Date:   Thu, 7 Oct 2021 19:39:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] net/netfilter/Kconfig: use 'default y' instead of 'm'
 for bool config option
Message-ID: <YV8wzUF13LAWNK6I@salvia>
References: <20211005205454.20244-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211005205454.20244-1-vegard.nossum@oracle.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 05, 2021 at 10:54:54PM +0200, Vegard Nossum wrote:
> From: Vegard Nossum <vegard.nossum@gmail.com>
> 
> This option, NF_CONNTRACK_SECMARK, is a bool, so it can never be 'm'.

Applied.
