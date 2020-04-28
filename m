Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA28C83001
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F2520746
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 15:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgD1Pl2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:41:28 -0400
Received: from correo.us.es ([193.147.175.20]:49350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgD1Pl1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 11:41:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96CE91F0CE2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87697BAC2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7D1DF2067B; Tue, 28 Apr 2020 17:41:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59489DA736
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 17:41:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4715642EF4E0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 17:41:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 0/9] netmap support for nft
Date:   Tue, 28 Apr 2020 17:41:11 +0200
Message-Id: <20200428154120.20061-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Another round of updates for the netmap support:

* Fix memleak when parsing set element data range.
* Convert range to prefix when listing.

Pablo Neira Ayuso (9):
  src: NAT support for intervals in maps
  include: resync nf_nat.h kernel header
  src: add netmap support
  src: add STMT_NAT_F_CONCAT flag and use it
  evaluate: fix crash when handling concatenation without map
  tests: py: concatenation, netmap and nat mappings
  mnl: restore --debug=netlink output with sets
  tests: py: remove range test with service names
  tests: shell: add NAT mappings tests

 include/expression.h                          |   2 +
 include/linux/netfilter/nf_nat.h              |  15 ++-
 include/statement.h                           |   8 +-
 src/evaluate.c                                |  50 +++++++-
 src/mnl.c                                     |  10 +-
 src/netlink.c                                 | 111 +++++++++++++++++-
 src/netlink_delinearize.                      |   0
 src/netlink_delinearize.c                     |  45 ++++++-
 src/netlink_linearize.c                       |  14 ++-
 src/parser_bison.y                            |  53 ++++++++-
 src/rule.c                                    |   3 +
 src/statement.c                               |   6 +-
 tests/py/inet/dccp.t                          |   1 -
 tests/py/ip/snat.t                            |   4 +
 tests/py/ip/snat.t.payload                    |  27 +++++
 tests/shell/testcases/sets/0046netmap_0       |  14 +++
 tests/shell/testcases/sets/0047nat_0          |  20 ++++
 .../testcases/sets/dumps/0046netmap_0.nft     |   6 +
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  13 ++
 19 files changed, 388 insertions(+), 14 deletions(-)
 create mode 100644 src/netlink_delinearize.
 create mode 100755 tests/shell/testcases/sets/0046netmap_0
 create mode 100755 tests/shell/testcases/sets/0047nat_0
 create mode 100644 tests/shell/testcases/sets/dumps/0046netmap_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0047nat_0.nft

-- 
2.20.1

