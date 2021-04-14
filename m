Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFE7C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03090613C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349780AbhDNIVf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 04:21:35 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45231 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349252AbhDNIVe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 04:21:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A2EFA5803DE;
        Wed, 14 Apr 2021 04:21:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 14 Apr 2021 04:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kXpKez4OKQc7e4WiW
        XAUpP5F1i2IQaGNUydhC+d4tEw=; b=G42QpYr+ewcW0Yq9zuT+kFoYNffFTBxuv
        a05LEfLcpZpVjyorbuLKHeDz94Fg0A83gkrgRNfCVuIBCiS19uc932FPMUY7Cfa9
        mUO98zUxROXMSse+ekl31Pr7+fJpd1CExIAtqCGS5yplZd4HroHuFJOw+65mhTS2
        MMHm8Q+mA17QjtrQqJCTtlFjqycAyqG8aOWYks9eXwdxCM7mzEEsgGP0derTITqN
        ytO6IadMbwD2RFgXYmQm3CcaAglV1x6aJJLXz5f28/itOP6k/ff6T8NSRapEkjaS
        h/BXTwwGLZcaDRv7WKwiVHKMC/+2WquWK8o4tUOAQe2qXqwXUFerw==
X-ME-Sender: <xms:96V2YJO-P6qntm14v3GhmfD90l_Gpnvmod0FvveW5mz1FwVvcOrBaQ>
    <xme:96V2YL9S1jP1o5e8MYmW1IcKJ0h4BMTNybnq3w2SQlUuHUKcZWbVKN-1gkJF8uLjh
    SzBNDEHNvMadrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrudekjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:96V2YIQtDYLbKl0j79rPRnQSwu2aWDFrOzRIWpc3xs1hvSAZ5B93CQ>
    <xmx:96V2YFtlFOnFuJnJBi-WFFIfy3BMktQZSPmQ4AiMQCt1yK6Cuh0IWw>
    <xmx:96V2YBeu5iZ79t_otkD3tSj75UHKVs3v-j9fERV5JUgMyBF9fiKzZw>
    <xmx:-KV2YLsKBuebWM3rs8qXI6hjC949Pe9D5-JmOkXwdBexyrxbXFgjJQ>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91A4224005A;
        Wed, 14 Apr 2021 04:21:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH nf-next v2 0/2] netfilter: Dissect flow after packet mangling
Date:   Wed, 14 Apr 2021 11:20:31 +0300
Message-Id: <20210414082033.1568363-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes a day-one bug in the interaction between netfilter and
sport/dport/ipproto FIB rule keys.

Patch #2 adds a corresponding test case.

Targeting at nf-next since this use case never worked.

v2:
* Add a test case

Ido Schimmel (2):
  netfilter: Dissect flow after packet mangling
  selftests: fib_tests: Add test cases for interaction with mangling

 net/ipv4/netfilter.c                     |   2 +
 net/ipv6/netfilter.c                     |   2 +
 tools/testing/selftests/net/fib_tests.sh | 152 ++++++++++++++++++++++-
 3 files changed, 155 insertions(+), 1 deletion(-)

-- 
2.30.2

