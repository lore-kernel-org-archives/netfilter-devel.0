Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF22C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 12:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjJZM0p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjJZM0p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 08:26:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825B5192
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 05:26:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qvzRc-0005ga-8Q; Thu, 26 Oct 2023 14:26:36 +0200
Date:   Thu, 26 Oct 2023 14:26:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 09/10] man: use .TP for lists in xt_osf man page
Message-ID: <ZTpa/DM6DyxywkWL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231026085506.94343-1-jengelh@inai.de>
 <20231026085506.94343-9-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026085506.94343-9-jengelh@inai.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 26, 2023 at 10:55:05AM +0200, Jan Engelhardt wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Value and description are more clearly set apart. Using .RS/.RE
> pairs also adds proper indenting.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  extensions/libxt_osf.man | 34 ++++++++++++++++++++++------------
>  1 file changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
> index 8bd35554..85c1a3b4 100644
> --- a/extensions/libxt_osf.man
> +++ b/extensions/libxt_osf.man
> @@ -8,24 +8,34 @@ Match an operating system genre by using a passive fingerprinting.
>  \fB\-\-ttl\fP \fIlevel\fP
>  Do additional TTL checks on the packet to determine the operating system.
>  \fIlevel\fP can be one of the following values:
> -.IP \(bu 4
> -0 - True IP address and fingerprint TTL comparison. This generally works for
> +.RS
> +.TP
> +\fB0\fP

What is wrong with '.B' here? I assumed it is equivalent to the escapes
(which I don't like for making things unreadable in most cases).

Cheers, Phil
