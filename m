Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D503FC64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 20:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCIUAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 15:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCIUAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 15:00:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B461FFA099;
        Thu,  9 Mar 2023 12:00:19 -0800 (PST)
Date:   Thu, 9 Mar 2023 21:00:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: Re: [ANNOUNCE] libnftnl 1.2.5 release
Message-ID: <ZAo60Btm0W3st8Ix@salvia>
References: <ZAo5g2gfD8z4OEs0@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZAo5g2gfD8z4OEs0@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 09, 2023 at 08:54:47PM +0100, Pablo Neira Ayuso wrote:
> Hi!
> 
> The Netfilter project proudly presents:
> 
>         libnftnl 1.2.5
> 
> libnftnl is a userspace library providing a low-level netlink
> programming interface (API) to the in-kernel nf_tables subsystem.
> This library is currently used by nftables.
> 
> This release includes two fixes for the printing of the set element
> user data area and the removal of an internal function without any
> clients.

This description is not correct: This release includes the inner
expression support, removal of deprecated functions from examples.

This release tarball is tar.xz instead tar.bz2.

Sorry for the incorrect description.

> See ChangeLog that comes attached to this email for more details on
> the updates.
> 
> You can download it from:
> 
> https://www.netfilter.org/projects/libnftnl/downloads.html
> 
> Happy firewalling.

> Pablo Neira Ayuso (5):
>       examples: remove nftnl_batch_is_supported() call
>       src: replace nftnl_*_nlmsg_build_hdr() by nftnl_nlmsg_build_hdr()
>       expr: add inner support
>       chain: relax logic to build NFTA_CHAIN_HOOK
>       build: libnftnl 1.2.5 release
> 
> Phil Sutter (1):
>       Makefile: Create LZMA-compressed dist-files
> 

