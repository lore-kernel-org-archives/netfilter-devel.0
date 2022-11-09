Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644CAC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 09:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiKIJjF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiKIJiw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 04:38:52 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9C78FD1A
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 01:38:44 -0800 (PST)
Date:   Wed, 9 Nov 2022 10:38:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] selftests: netfilter: Fix and review rpath.sh
Message-ID: <Y2t1IKo+kof2OrBQ@salvia>
References: <20221109090604.18439-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221109090604.18439-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 09, 2022 at 10:06:04AM +0100, Phil Sutter wrote:
> Address a few problems with the initial test script version:
> 
> * On systems with ip6tables but no ip6tables-legacy, testing for
>   ip6tables was disabled by accident.
> * Firewall setup phase did not respect possibly unavailable tools.
> * Consistently call nft via '$nft'.

Applied to nf.git, thanks
