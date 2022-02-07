Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50720C4167D
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 18:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbiBGSCS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 13:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344684AbiBGR7S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 12:59:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A360CC0401D9
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 09:59:17 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E7BF3601C0;
        Mon,  7 Feb 2022 18:59:12 +0100 (CET)
Date:   Mon, 7 Feb 2022 18:59:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_conntrack PATCH 1/2] tests: Fix for missing
 qa-connlabel.conf in tarball
Message-ID: <YgFd8jxWZlgNedX7@salvia>
References: <20220207135048.17147-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220207135048.17147-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Series LGTM. Thanks

On Mon, Feb 07, 2022 at 02:50:47PM +0100, Phil Sutter wrote:
> Register the file as extra dist so 'make dist' picks it up.
> 
> Fixes: 6510a98f4139f ("api: add connlabel api and attribute")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/Makefile.am | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/Makefile.am b/tests/Makefile.am
> index 20ebaf2e5b851..56c78d9424326 100644
> --- a/tests/Makefile.am
> +++ b/tests/Makefile.am
> @@ -3,6 +3,8 @@ include $(top_srcdir)/Make_global.am
>  check_PROGRAMS = test_api test_filter test_connlabel ct_stress \
>  	ct_events_reliable
>  
> +EXTRA_DIST = qa-connlabel.conf
> +
>  test_api_SOURCES = test_api.c
>  test_api_LDADD = ../src/libnetfilter_conntrack.la
>  
> -- 
> 2.34.1
> 
