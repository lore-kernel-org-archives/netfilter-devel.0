Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCE0C43334
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jun 2022 14:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245731AbiFGOlv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 10:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245727AbiFGOlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 10:41:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAA68C17C1;
        Tue,  7 Jun 2022 07:41:46 -0700 (PDT)
Date:   Tue, 7 Jun 2022 16:41:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.4 release
Message-ID: <Yp9jp9XwOtcNaBCe@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uYBAG99Q7XAC+1B/"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--uYBAG99Q7XAC+1B/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.4

This is an incremental release accumulating bugfixes for two
regressions that were introduced in 1.0.3:

* Fix segfault in -o/--optimize with unsupported statements:
  http://git.netfilter.org/nftables/commit/?id=59bd944f6d75e99fe0c8d743e7fd482672640c2d

* Bogus datatype mismatch error report in sets:
  http://git.netfilter.org/nftables/commit/?id=818f7dded9c9e8a89a2de98801425536180ae307

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.2.2 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--uYBAG99Q7XAC+1B/
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.4.txt"

Pablo Neira Ayuso (5):
      optimize: segfault when releasing unsupported statement
      tests: shell: sets_with_ifnames release netns on exit
      evaluate: reset ctx->set after set interval evaluation
      tests: shell: remove leftover modules on cleanup
      build: Bump version to 1.0.4


--uYBAG99Q7XAC+1B/--
