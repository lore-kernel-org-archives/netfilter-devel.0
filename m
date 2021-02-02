Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B42C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 13:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD06364F5D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 13:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBBNWg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:22:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231290AbhBBNWd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 08:22:33 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-lKDvItlsNBqHhC4wCE1skg-1; Tue, 02 Feb 2021 08:21:04 -0500
X-MC-Unique: lKDvItlsNBqHhC4wCE1skg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04FB3107ACF6;
        Tue,  2 Feb 2021 13:21:03 +0000 (UTC)
Received: from localhost (ovpn-113-65.rdu2.redhat.com [10.10.113.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDF685C1CF;
        Tue,  2 Feb 2021 13:21:02 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:21:02 -0500
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Michael Biebl <biebl@debian.org>
Subject: Re: [PATCH nft 2/2] payload: check icmp dependency before removing
 previous icmp expression
Message-ID: <20210202132102.GY3286651@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Michael Biebl <biebl@debian.org>
References: <20210201215005.26612-1-fw@strlen.de>
 <20210201215005.26612-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201215005.26612-2-fw@strlen.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 01, 2021 at 10:50:04PM +0100, Florian Westphal wrote:
> nft is too greedy when removing icmp dependencies.
> 'icmp code 1 type 2' did remove the type when printing.
> 
> Be more careful and check that the icmp type dependency of the
> candidate expression (earlier icmp payload expression) has the same
> type dependency as the new expression.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Reported-by: Michael Biebl <biebl@debian.org>
> Fixes: d0f3b9eaab8d77e ("payload: auto-remove simple icmp/icmpv6 dependency expressions")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Tested-by: Eric Garver <eric@garver.life>

Thanks Florian. This fixes the issue [1] reported against firewalld.

[1]: https://github.com/firewalld/firewalld/issues/752

--->8---

--- -	2021-02-01 16:02:58.854101473 +0000
+++ /tmp/autopkgtest.PRXtPH/build.yiS/src/src/tests/testsuite.dir/at-groups/97/stdout	2021-02-01 16:02:58.846718150 +0000
@@ -1,6 +1,6 @@
 table inet firewalld {
 chain filter_IN_public_deny {
-icmp type destination-unreachable icmp code host-prohibited reject with icmpx type admin-prohibited
+icmp code host-prohibited reject with icmpx type admin-prohibited
 }
 }

