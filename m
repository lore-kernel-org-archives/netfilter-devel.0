Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C41C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Apr 2022 02:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241926AbiDTC4s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 22:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiDTC4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 22:56:48 -0400
X-Greylist: delayed 914 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Apr 2022 19:54:01 PDT
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D93F136B6B
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2022 19:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=g8PQp
        STV8COHj1YBXIG7zGSs5B/bzL/E2H3NRoKIaZE=; b=d0npGDG7/cGuB6Nv4Exvr
        5tsyyPTTmpN+Edn9Ub+mkLsR8S+KpV4+y/Z7hQsKFK4Rx/GOsHKwOK74k9LF/bbs
        JelLiPSc6U5uqnQ4v/9CQoxd5PtLkZvApNZ68NMK1JwbkruPGYtSV89QCLLuKSI+
        VTDCd4fwcFm9rwucQnLPTw=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp1 (Coremail) with SMTP id GdxpCgCXXb4ucl9itd0oCA--.3059S2;
        Wed, 20 Apr 2022 10:38:39 +0800 (CST)
From:   clement wei <clementwei90@163.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, xiaolinkui@kylinos.cn,
        Rongguang Wei <weirongguang@kylinos.cn>
Subject: [PATCH v1] netfilter: Remove the empty file
Date:   Wed, 20 Apr 2022 10:38:04 +0800
Message-Id: <20220420023804.2018968-1-clementwei90@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgCXXb4ucl9itd0oCA--.3059S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw1xJrWxWr1fWw4kJFyrJFb_yoWxAFc_Gr
        Wktw1kKFWrJF93Cw47Cr4rJF1rKry7CFyfAa4xXFWDt345Jw40vrZ7ZFyv9r93Cwsrury5
        Ar1ktas7A3y29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUejZX7UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5fohzv5qwzvxizq6il2tof0z/1tbiXAHoa1Xl2UBiTQACsa
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Rongguang Wei <weirongguang@kylinos.cn>

CONFIG_NF_FLOW_TABLE_IPV4 is already removed and the real user is also
removed(nf_flow_table_ipv4.c is empty).

Fixes: c42ba4290b2147aa ("netfilter: flowtable: remove ipv4/ipv6 modules")
---
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c

diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus

