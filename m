Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C740C38BE0
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 18:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 659A720838
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 18:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCmLeD/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgBXSzw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:55:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727426AbgBXSzw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 13:55:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582570550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qmy+/DcMDdUSTfHqKJLRQ4XAfLyXoIHclUXkSdOie50=;
        b=NCmLeD/RVoK2OcOb9iYPnBQwTMald18Bhh2Xol6+zK6D4nyuDDZf4MRYpD5+pUc4R/A1eN
        gJqi2YzIQdtpD/lQ+q34yhssi/HeC8Hy0ZqZFf3s4FkejuMiWb7K1iC/fXSHVk3G03Fu8E
        iORl2RIXgYgd31I9m6eMivmQqvyw0Cg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-P4A38xtuNf-rKtuNhP9CbA-1; Mon, 24 Feb 2020 13:55:48 -0500
X-MC-Unique: P4A38xtuNf-rKtuNhP9CbA-1
Received: by mail-wr1-f71.google.com with SMTP id t3so4247085wrp.2
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 10:55:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qmy+/DcMDdUSTfHqKJLRQ4XAfLyXoIHclUXkSdOie50=;
        b=i+cYbQiImOd6M9S9bUyWAw7p3goW7m2jpUTGiOR2g8X7CAbIXI1CoOY10FjSYuM8R6
         eqy6C5a4oIr4leieIfmnCFacNbjaic7Loro7OlXaLcOPEXQeU2wG+rRVdkLR8KZZTAw1
         KWI021f51Ph3l+49KSE+aKUFIbG3p66HD/o0TuxCsv129/UDtJJ53WouXzpt3rCwWgQK
         gVJ8MqYa1RxIotQQk0ITCdYl/Tilwj0o86593vq/jrD0+flDMICi1dkg32hzcTbEmg8N
         YolzgDuKTXvwiruwbRYACzobE/nRhBY3Owov1tXiMafd6OJHXixBh/Tyyn+VASzxY0/1
         ywuA==
X-Gm-Message-State: APjAAAWedlIeCfRemWlk4mWHb+qcc+tmnNHuz6Z76HG7UxVpRkv4zM32
        yjcnj6Xvbh5YliCS6t0DQbapi2vuhU8kuMgxrFMbs5FsbUjTGv0BXlpdCPTUYqo7NQypcZ03dJd
        W8kPp3US92xffDkpa49AHrlKaSz9z
X-Received: by 2002:a1c:f712:: with SMTP id v18mr231893wmh.155.1582570547366;
        Mon, 24 Feb 2020 10:55:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzLfrB7CCT2bx+Wtk4qiWRW9LrVB55nuO7bRVFcYHNgHZmNeHEgXbVGS3DRcBeETJNyhQeCjg==
X-Received: by 2002:a1c:f712:: with SMTP id v18mr231880wmh.155.1582570547171;
        Mon, 24 Feb 2020 10:55:47 -0800 (PST)
Received: from raver.teknoraver.net (net-47-53-225-50.cust.vodafonedsl.it. [47.53.225.50])
        by smtp.gmail.com with ESMTPSA id c15sm19949531wrt.1.2020.02.24.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 10:55:46 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf] netfilter: ensure rcu_read_lock() in ipv4_find_option()
Date:   Mon, 24 Feb 2020 19:55:29 +0100
Message-Id: <20200224185529.50530-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
__ip_options_compile() must be called under rcu protection.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/netfilter/nft_exthdr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a5e8469859e3..752264b3043a 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -77,6 +77,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	bool found = false;
 	__be32 info;
 	int optlen;
+	int ret;
 
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
@@ -95,7 +96,11 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 		return -EBADMSG;
 	opt->optlen = optlen;
 
-	if (__ip_options_compile(net, opt, NULL, &info))
+	rcu_read_lock();
+	ret = __ip_options_compile(net, opt, NULL, &info);
+	rcu_read_unlock();
+
+	if (ret)
 		return -EBADMSG;
 
 	switch (target) {
-- 
2.24.1

