Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CFAC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 21:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377112AbhLBVnM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:43:12 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57452 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbhLBVnL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 16:43:11 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 92422607C3;
        Thu,  2 Dec 2021 22:37:29 +0100 (CET)
Date:   Thu, 2 Dec 2021 22:39:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/5] Reduce cache overhead a bit
Message-ID: <Yak9H3FOc98/T7Ri@salvia>
References: <20211202131136.29242-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211202131136.29242-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 02, 2021 at 02:11:31PM +0100, Phil Sutter wrote:
> Second try after a quick review and some testing:
> 
> - Tested with stable kernels v4.4.293 and v4.9.291: This series does not
>   change any of the shell tests' results. The changes are supposedly
>   bug- and feature-compatible.

LGTM, thanks
