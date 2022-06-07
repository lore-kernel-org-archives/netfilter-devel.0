Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D54C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jun 2022 14:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiFGOhX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 10:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242959AbiFGOhX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 10:37:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39422EABAF;
        Tue,  7 Jun 2022 07:37:22 -0700 (PDT)
Date:   Tue, 7 Jun 2022 16:37:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.2 release
Message-ID: <Yp9intemtsFLlZWh@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9dxThqyU9FsFkAsw"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9dxThqyU9FsFkAsw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.2

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--9dxThqyU9FsFkAsw
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.2.txt"

Florian Westphal (1):
      exthdr: tcp option reset support

Pablo Neira Ayuso (2):
      set_elem: missing export symbol
      build: libnftnl 1.2.2 release


--9dxThqyU9FsFkAsw--
