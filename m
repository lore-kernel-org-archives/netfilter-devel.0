Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B97C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3207621582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLQRRK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:10 -0500
Received: from correo.us.es ([193.147.175.20]:37904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLQRRJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0655A1C4424
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB2C4DA70D
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0EBDDA702; Tue, 17 Dec 2019 18:17:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7446DA702;
        Tue, 17 Dec 2019 18:17:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CECEA4265A5A;
        Tue, 17 Dec 2019 18:17:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 00/11] complete typeof support
Date:   Tue, 17 Dec 2019 18:16:51 +0100
Message-Id: <20191217171702.31493-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

This completes your patchset adding typeof support for the remaining
primary expression.

Feel free to apply and push this out on top of your patchset.

P.S: testcases/maps/typeof_maps_0 fails:

/dev/stdin:14:28-30: Error: datatype mismatch, map expects string,
mapping expression has type IPv4 address
                ct mark set ip daddr map @m1
                            ~~~~~~~~     ^^^

There is a typo in the map definition:

/dev/stdin:14:28-30: Error: datatype mismatch, map expects string,
mapping expression has type IPv4 address
                ct mark set ip daddr map @m1
                            ~~~~~~~~     ^^^

This should be

                ct mark set osf name map @m1

dump file also needs an adjustment, you can fix this before pushing
this out.

Thanks!

P.S: I might follow up at some point to expose this userdata
attributes through libnftnl, later. Meanwhile, I have just pushed
out the libnftnl nesting dependencies.

Pablo Neira Ayuso (11):
  meta: add parse and build userdata interface
  exthdr: add exthdr_desc_id enum and use it
  exthdr: add parse and build userdata interface
  socket: add parse and build userdata interface
  osf: add parse and build userdata interface
  ct: add parse and build userdata interface
  numgen: add parse and build userdata interface
  hash: add parse and build userdata interface
  rt: add parse and build userdata interface
  fib: add parse and build userdata interface
  xfrm: add parse and build userdata interface

 include/exthdr.h |  15 ++++++++
 src/ct.c         |  56 ++++++++++++++++++++++++++++++
 src/expression.c |  13 +++++--
 src/exthdr.c     | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/fib.c        |  60 ++++++++++++++++++++++++++++++--
 src/hash.c       |  72 +++++++++++++++++++++++++++++++++++++++
 src/meta.c       |  51 ++++++++++++++++++++++++++++
 src/numgen.c     |  62 +++++++++++++++++++++++++++++++++
 src/osf.c        |  13 +++++++
 src/rt.c         |  51 ++++++++++++++++++++++++++++
 src/socket.c     |  51 ++++++++++++++++++++++++++++
 src/xfrm.c       |  61 +++++++++++++++++++++++++++++++++
 12 files changed, 603 insertions(+), 4 deletions(-)

-- 
2.11.0

