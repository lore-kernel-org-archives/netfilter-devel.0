Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E37C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3614420674
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfLBNOP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 08:14:15 -0500
Received: from correo.us.es ([193.147.175.20]:49316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfLBNOO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:14:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77DE5A1A341
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:14:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68174DA703
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:14:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5D754DA70D; Mon,  2 Dec 2019 14:14:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 471EADA703;
        Mon,  2 Dec 2019 14:14:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 14:14:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 15FC542EE38E;
        Mon,  2 Dec 2019 14:14:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH,nf-next RFC 0/2] add NFTA_SET_ELEM_KEY_END
Date:   Mon,  2 Dec 2019 14:14:05 +0100
Message-Id: <20191202131407.500999-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

This patchset extends the netlink API to allow to express an interval
with one single element.

This simplifies this interface since userspace does not need to send two
independent elements anymore, one of the including the
NFT_SET_ELEM_INTERVAL_END flag.

The idea is to use the _DESC to specify that userspace speaks the kernel
that new API representation. In your case, the new description attribute
that tells that this set contains interval + concatenation implicitly
tells the kernel that userspace supports for this new API.

If you're fine with this, I can scratch a bit of time to finish the
libnftnl part. The nft code will need a small update too. You will not
need to use the nft_set_pipapo object as scratchpad area anymore.

Compile-tested only.

Let me know, thanks.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: add nft_setelem_parse_key()
  netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute

 include/net/netfilter/nf_tables.h        |  14 +++-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 134 +++++++++++++++++++++----------
 net/netfilter/nft_dynset.c               |   2 +-
 4 files changed, 106 insertions(+), 46 deletions(-)

--
2.11.0

