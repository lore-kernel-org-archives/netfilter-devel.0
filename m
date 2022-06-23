Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5D9C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 19:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiFWTjy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiFWTji (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 15:39:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A8B66478C
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 12:28:33 -0700 (PDT)
Date:   Thu, 23 Jun 2022 21:28:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 5/6] tests/conntrack: ct -o save for unknown protocols
Message-ID: <YrS+3kLsobLtwmBP@salvia>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
 <20220623175000.49259-6-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623175000.49259-6-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 07:49:59PM +0200, Mikhail Sennikovsky wrote:
> Testcases covering dumping in -o save formate of ct entries of
> L4 protocols unknown to the conntrack tool,
> which does not work properly at the moment.
> Fix included in the next commit.

Could you collapse the test to the relevant patch (next commit as
description suggests)? I find this easier to find when looking at git
annotate.

> Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> ---
>  tests/conntrack/testsuite/09dumpopt | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
> index 447590b..c1e0e6e 100644
> --- a/tests/conntrack/testsuite/09dumpopt
> +++ b/tests/conntrack/testsuite/09dumpopt
> @@ -145,3 +145,29 @@
>  -D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
>  # clean up after yourself
>  -D -w 10 ; OK
> +# Cover protocols unknown to the conntrack tool
> +# Create a conntrack entries
> +# IGMP
> +-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ;
> +# Some fency protocol
> +-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ;
> +# Some fency protocol with IPv6
> +-I -w 10 -t 59 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ;
> +-R - ; OK
> +# copy to zone 11
> +-L -w 10 -o save ; |s/-w 10/-w 11/g
> +-R - ; OK
> +# Delete stuff in zone 10, should succeed
> +# IGMP
> +-D -w 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
> +# Some fency protocol
> +-D -w 10  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
> +# Some fency protocol with IPv6
> +-D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
> +# Delete stuff in zone 11, should succeed
> +# IGMP
> +-D -w 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
> +# Some fency protocol
> +-D -w 11  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
> +# Some fency protocol with IPv6
> +-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
> -- 
> 2.25.1
> 
