Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F70EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jul 2023 16:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjGKQ7E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjGKQ7E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jul 2023 12:59:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88D2F95;
        Tue, 11 Jul 2023 09:59:02 -0700 (PDT)
Date:   Tue, 11 Jul 2023 18:58:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.6 release
Message-ID: <ZK2KUlzZzlQ8/mKa@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mSGEbGQnIBDK8HSy"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mSGEbGQnIBDK8HSy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.6

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release includes meta broute support.

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--mSGEbGQnIBDK8HSy
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.6.txt"

Pablo Neira Ayuso (1):
      build: libnftnl 1.2.6 release

Sriram Yagnaraman (1):
      expr: meta: introduce broute meta expression

shixuantong (2):
      tests: nft-table-test: fix typo
      tests: nft-rule-test: Add test cases to improve code coverage


--mSGEbGQnIBDK8HSy--
