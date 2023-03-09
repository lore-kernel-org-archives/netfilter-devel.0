Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B612C64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 19:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCITyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCITyt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 14:54:49 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D48AF8F13;
        Thu,  9 Mar 2023 11:54:48 -0800 (PST)
Date:   Thu, 9 Mar 2023 20:54:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.5 release
Message-ID: <ZAo5g2gfD8z4OEs0@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wwWqwfWRtgetfK/F"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wwWqwfWRtgetfK/F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.5

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release includes two fixes for the printing of the set element
user data area and the removal of an internal function without any
clients.

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--wwWqwfWRtgetfK/F
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.5.txt"

Pablo Neira Ayuso (5):
      examples: remove nftnl_batch_is_supported() call
      src: replace nftnl_*_nlmsg_build_hdr() by nftnl_nlmsg_build_hdr()
      expr: add inner support
      chain: relax logic to build NFTA_CHAIN_HOOK
      build: libnftnl 1.2.5 release

Phil Sutter (1):
      Makefile: Create LZMA-compressed dist-files


--wwWqwfWRtgetfK/F--
