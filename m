Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A22DC2D0C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16D020726
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLPMmb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:42:31 -0500
Received: from correo.us.es ([193.147.175.20]:32846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfLPMmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 07:42:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6839E2C6C
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97AC4DA715
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D806DA714; Mon, 16 Dec 2019 13:42:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CB8DDA70C;
        Mon, 16 Dec 2019 13:42:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 13:42:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2672042EF42C;
        Mon, 16 Dec 2019 13:42:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 0/3] typeof incremental enhancements
Date:   Mon, 16 Dec 2019 13:42:19 +0100
Message-Id: <20191216124222.356618-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

This patchset removes the need to self invoke the parser and the
evaluation to fetch the datatype. Instead, the expression type and
the expression description are stored into the userdata area.

This patch only supports for the payload expression, but it should be
relatively easy to extend it to support for other existing expressions
types.

This patch could be squashed into 06/11 src: add "typeof" print support
of your patch series, which is actually not just adding support for
printing but also for building the userdata.

Thanks.

Pablo Neira Ayuso (3):
  proto: add proto_desc_id enumeration
  expr: add expr_ops_by_type()
  expr: add parse and build userdata interface

 include/expression.h |   5 +++
 include/proto.h      |  27 +++++++++++++
 src/expression.c     |  12 ++++++
 src/mnl.c            |  28 +++++---------
 src/netlink.c        | 105 +++++++++++++++++----------------------------------
 src/payload.c        |  80 +++++++++++++++++++++++++++++++++++++++
 src/proto.c          |  46 ++++++++++++++++++++++
 7 files changed, 214 insertions(+), 89 deletions(-)

-- 
2.11.0

