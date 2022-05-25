Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 11:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiEYLEe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 07:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiEYLEa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 07:04:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41792338AC
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 04:04:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ntooT-0002gD-0j; Wed, 25 May 2022 13:04:25 +0200
Date:   Wed, 25 May 2022 13:04:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Ben Brown <ben@demerara.io>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] build: Fix error during out of tree build
Message-ID: <Yo4NOcCsPPCM5h+6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Ben Brown <ben@demerara.io>,
        netfilter-devel@vger.kernel.org
References: <d454c825-2d43-56d9-d001-e98308d2dd1b@demerara.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d454c825-2d43-56d9-d001-e98308d2dd1b@demerara.io>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 19, 2022 at 07:07:23PM +0100, Ben Brown wrote:
> From a7a2f49a53ce5487a9869cd44b647de0882c6996 Mon Sep 17 00:00:00 2001
> From: Ben Brown <ben@demerara.io>
> Date: Thu, 19 May 2022 18:50:25 +0100
> Subject: [PATCH] build: Fix error during out of tree build
> 
> Fixes the following error:
> 
>     ../../libxtables/xtables.c:52:10: fatal error: libiptc/linux_list.h:
> No such file or directory
>        52 | #include <libiptc/linux_list.h>
> 
> Signed-off-by: Ben Brown <ben@demerara.io>

Your mailer broke the patch by breaking long lines. Please use
git-send-email to submit patches, it's a lot less error-prone.

When resubmitting, also please add:

Fixes: f58b0d7406451 ("libxtables: Implement notargets hash table")

Apart from that, looks good to me!

Thanks, Phil
