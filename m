Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AF8C4167E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 21:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiDEVUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450184AbiDEPvT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 11:51:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609141275B9;
        Tue,  5 Apr 2022 07:39:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nbkLO-0004be-Lh; Tue, 05 Apr 2022 16:39:42 +0200
Date:   Tue, 5 Apr 2022 16:39:42 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnfnetlink 1.0.2 release
Message-ID: <YkxUru2QG/o1BlTV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PfK1Du911qYl3QzP"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--PfK1Du911qYl3QzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnfnetlink 1.0.2

This release contains only fixes:

* Warnings with automake-1.12
* Update header comments to reflect GPLv2+ license
* Allow building on uclinux
* Valgrind warnings due to uninitialized padding in netlink messages
* Hide private library symbols
* Support builds with newer doxygen versions
* Failing calls to getsockname() were left unnoticed

You can download the new release from:

https://netfilter.org/projects/libnfnetlink/downloads.html#libnfnetlink-1.0.2

Note that despite the new release, this library remains deprecated and
users should migrate to libmnl if possible.

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--PfK1Du911qYl3QzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnfnetlink-1.0.2.txt"

Duncan Roe (2):
      Minimally resurrect doxygen documentation
      Make it clear that this library is deprecated

Felix Janda (2):
      include: Sync with kernel headers
      src: Use stdint types everywhere

Gustavo Zacarias (1):
      configure: uclinux is also linux

Jan Engelhardt (1):
      build: resolve automake-1.12 warnings

Pablo Neira Ayuso (5):
      src: get source code license header in sync with current licensing terms
      libnfnetlink: initialize attribute padding to resolve valgrind warnings
      autogen: don't convert __u16 to u_int16_t
      bump version to 1.0.2
      build: add nfnl.version to sources

Phil Sutter (2):
      include: Silence gcc warning in linux_list.h
      libnfnetlink: Check getsockname() return code

Yury Gribov (1):
      libnfnetlink: hide private symbols


--PfK1Du911qYl3QzP--
