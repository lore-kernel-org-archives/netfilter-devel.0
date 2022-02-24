Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285D2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 23:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiBXXiq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiBXXiq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 18:38:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A983118E3EE
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:38:15 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F36E26433D;
        Fri, 25 Feb 2022 00:37:05 +0100 (CET)
Date:   Fri, 25 Feb 2022 00:38:12 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sam James <sam@gentoo.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] build: explicitly pass --version-script to linker
Message-ID: <YhgW5Be32UGbMPG4@salvia>
References: <20220224194543.59581-1-sam@gentoo.org>
 <20220224194543.59581-2-sam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220224194543.59581-2-sam@gentoo.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 24, 2022 at 07:45:43PM +0000, Sam James wrote:
> --version-script is a linker option, so let's use -Wl, so that
> libtool handles it properly. It seems like the previous method gets silently
> ignored with GNU libtool in some cases(?) and downstream in Gentoo,
> we had to apply this change to make the build work with slibtool anyway.
> 
> But it's indeed correct in any case, so let's swap.

Also applied, thanks
