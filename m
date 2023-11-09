Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D627C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjKIQGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbjKIQGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:06:02 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2DA19A5
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:06:00 -0800 (PST)
Received: from [78.30.43.141] (port=36094 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r17XY-00FIpL-M4; Thu, 09 Nov 2023 17:05:58 +0100
Date:   Thu, 9 Nov 2023 17:05:55 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/4] [RESENT] remove xfree() and add
 free_const()+nft_gmp_free()
Message-ID: <ZU0DY9x7h5q1och2@calendula>
References: <20231024095820.1068949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024095820.1068949-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 11:57:06AM +0200, Thomas Haller wrote:
> RESENT of v1.
> 
> Also rebased on top of current `master`, which required minor
> adjustments.
> 
> Also minor adjustments to the commit messages.

Applied.

To be honest, reading the longish commit descriptions several times, I
doubt there is any benefit in this, I might end up myself using
free_const() everywhere not to figure out if it is const or not,
because I don't really care.

But now this series are in master.
