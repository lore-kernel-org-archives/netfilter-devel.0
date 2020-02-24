Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7ECC11D32
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2920420828
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UnPrK2Hm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgBXMte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
Received: from kadath.azazel.net ([81.187.231.250]:57312 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgBXMte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DzYUbc0/8lUyzwGiAtpJRVDEinTyZyasFfvebKFtgBo=; b=UnPrK2Hmdu4gtFJgWcwzrMIQCH
        NJcN9xqJ+htHRrMIY036OpqyjnMf4RjBBwJU+KgqoPJjfHdve1z+TzC8I9GTMYHZzf4+XuN9kPTDm
        VijX8HKO4N8Aap9YaKRtGYU2AyS+pBWnyEcLpacheIl08KICXecl16VmXw7+xuFxYogIG5NwInw42
        K78nU14zJUBaMa49rnc5XVWABn7PSik1pPof1plZaITlEycFR+5P0b9SuqZzbTXrz/8SNYggmOyMQ
        pjnhsNhdGserL2nhDpGHJ/KwFb6VtipA9Bz/KDrfAnj17VWrbcWC2z8rZ84x5gvdnazLoTbHDCTKp
        Rj9qjbcA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DAy-0001eE-2i; Mon, 24 Feb 2020 12:49:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/2] netfilter: bitwise: support variable RHS operands
Date:   Mon, 24 Feb 2020 12:49:29 +0000
Message-Id: <20200224124931.512416-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently bitwise boolean operations can only have one variable operand
because the mask and xor values have to be passed as immediate data.
Support operations with two variable operands by allowing the mask and
xor to be passed in registers.

There is a preliminary patch that renames a couple of variables.

Jeremy Sowden (2):
  netfilter: bitwise: use more descriptive variable-names.
  netfilter: bitwise: add support for passing mask and xor values in
    registers.

 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/netfilter/nft_bitwise.c              | 120 +++++++++++++++++------
 2 files changed, 94 insertions(+), 30 deletions(-)

-- 
2.25.0

