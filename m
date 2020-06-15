Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E9EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 20:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 521852078E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 20:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbgFOUnW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 16:43:22 -0400
Received: from correo.us.es ([193.147.175.20]:59778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbgFOUnV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 16:43:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5C16F9264
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 22:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 937EADA78B
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 22:43:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 89505DA72F; Mon, 15 Jun 2020 22:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2652DA72F;
        Mon, 15 Jun 2020 22:43:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jun 2020 22:43:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D37EB42EE38F;
        Mon, 15 Jun 2020 22:43:16 +0200 (CEST)
Date:   Mon, 15 Jun 2020 22:43:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] nftables 0.9.6 release
Message-ID: <20200615204316.GA24277@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.9.6

This release fixes vmap support which broke in 0.9.5.

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.6
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl 1.1.7 and libmnl >= 1.0.4 are required:

* http://netfilter.org/projects/libnftnl/index.html
* http://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* http://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Have fun.

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-nftables-0.9.6.txt"

Fabrice Fontaine (1):
      main: fix build with gcc <= 4.8

Pablo Neira Ayuso (8):
      evaluate: missing datatype definition in implicit_set_declaration()
      evaluate: remove superfluous check in set_evaluate()
      netlink: release dummy rule object from netlink_parse_set_expr()
      segtree: fix asan runtime error
      meta: fix asan runtime error in tc handle
      cmd: add misspelling suggestions for rule commands
      tests: shell: rename testcases/map/dump/0009vmap_0dump.nft
      build: Bump version to v0.9.6


--6c2NcOVqGQ03X4Wi--
