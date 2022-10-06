Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1C4C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJFA25 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJFA24 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47D282D13
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e9XMQGTUntkfSXbsWAanZQxruRDrHurCQ1SyOFloES8=; b=L+kzP2wNY2tZKRe7QC7qZT20MX
        nOBhRi6YbHwnfM0P1NF9BMtPJLmkeMaKMUoMzSA7QMTg/GqLS+AKvT/BgK0xOGKY2y5Jt3183+WKv
        vImsg184yWUHIUd5Cb1b17cWeIuh7q110L3uL+9TtI5I3Sz1vdyGa41LtPAIBMEkfAPn9su9CSB3U
        qzXEA4TjlMapOaqrbXrR0CiqfZMq43QcQjOOGgIsHXj/4tWjgfe9XxQIaV/hbUZ8ReIKmSAXHoPAQ
        p5jTiJHjhrwy9Yy3HtQ8eqkROOX8GxY6zFcgH6W8HS1pqhrrxZWDmIOUC3KDmQ46AUm7VOsGF0dwF
        /mLJCaGQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkv-0001yz-Lj; Thu, 06 Oct 2022 02:28:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 03/12] tests: *.t: Fix expected output for simple calls
Date:   Thu,  6 Oct 2022 02:27:53 +0200
Message-Id: <20221006002802.4917-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These minimal extension uses print in more detailed form. Track this,
the output is desired.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_log.t     | 2 +-
 extensions/libebt_nflog.t   | 2 +-
 extensions/libip6t_REJECT.t | 2 +-
 extensions/libipt_REJECT.t  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libebt_log.t b/extensions/libebt_log.t
index f7116c417b0ab..e6adbd3b44380 100644
--- a/extensions/libebt_log.t
+++ b/extensions/libebt_log.t
@@ -1,5 +1,5 @@
 :INPUT,FORWARD,OUTPUT
---log;=;OK
+--log;--log-level notice;OK
 --log-level crit;=;OK
 --log-level 1;--log-level alert;OK
 --log-level emerg --log-ip --log-arp --log-ip6;=;OK
diff --git a/extensions/libebt_nflog.t b/extensions/libebt_nflog.t
index f867df303fa95..e98d8f5fdb9d6 100644
--- a/extensions/libebt_nflog.t
+++ b/extensions/libebt_nflog.t
@@ -1,5 +1,5 @@
 :INPUT,FORWARD,OUTPUT
---nflog;=;OK
+--nflog;--nflog-group 1;OK
 --nflog-group 42;=;OK
 --nflog-range 42;--nflog-group 1 --nflog-range 42 -j CONTINUE;OK
 --nflog-threshold 100 --nflog-prefix foo;--nflog-prefix "foo" --nflog-group 1 --nflog-threshold 100 -j CONTINUE;OK
diff --git a/extensions/libip6t_REJECT.t b/extensions/libip6t_REJECT.t
index d2b337d7ebdeb..8294f0bb77b29 100644
--- a/extensions/libip6t_REJECT.t
+++ b/extensions/libip6t_REJECT.t
@@ -1,5 +1,5 @@
 :INPUT,FORWARD,OUTPUT
--j REJECT;=;OK
+-j REJECT;-j REJECT --reject-with icmp6-port-unreachable;OK
 # manpage for IPv6 variant of REJECT does not show up for some reason?
 -j REJECT --reject-with icmp6-no-route;=;OK
 -j REJECT --reject-with icmp6-adm-prohibited;=;OK
diff --git a/extensions/libipt_REJECT.t b/extensions/libipt_REJECT.t
index 5b26b1076b5b2..3f69a72994955 100644
--- a/extensions/libipt_REJECT.t
+++ b/extensions/libipt_REJECT.t
@@ -1,5 +1,5 @@
 :INPUT,FORWARD,OUTPUT
--j REJECT;=;OK
+-j REJECT;-j REJECT --reject-with icmp-port-unreachable;OK
 -j REJECT --reject-with icmp-net-unreachable;=;OK
 -j REJECT --reject-with icmp-host-unreachable;=;OK
 -j REJECT --reject-with icmp-port-unreachable;=;OK
-- 
2.34.1

