Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10307C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 14:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350713AbiCXOFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 10:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCXOFV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 10:05:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6AC369E8
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2022 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=92tkyQyMPB6WQk5DwO/6E5MZgEdEZA2HPhBI05yrGFA=; b=k+IrCulsVUkXs9AFzaPYEnSk/A
        uIiKQ1A97CnE/NizAQhcuaZsD3/91bXYr0AHeKTHqlZh4e3VbXZjMZxlqaF7K1mLO7LabIJFkCh6x
        a28ODvYFgM368r+3rxV/n/xTL4Aa96tMSojvKr3ILWKrVrTneko1qrUogkGJ+RCWkiYO7glSYsnLB
        vLoZNLE5tIgJufCkJQYFiGA6Yxpr6dFmMvTtWuvZfQJwNgPVX02bnBGHM246K7fucPrDTzEK8zk2c
        E4rwJ3Z8FtPrMMqWEAxA5lxEYn8hXg9MPcdFIw2Y7FkRztA3ZKMagtC5VAon89gqKRiHD4ELqhleY
        ky+sPyOw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXO44-0002y6-8Q; Thu, 24 Mar 2022 15:03:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/2] netfilter: nf_log_syslog: Don't ignore unknown protocols
Date:   Thu, 24 Mar 2022 15:03:41 +0100
Message-Id: <20220324140341.24259-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220324140341.24259-1-phil@nwl.cc>
References: <20220324140341.24259-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With netdev and bridge nfprotos, loggers may see arbitrary ethernet
frames. Print at least basic info like interfaces and MAC header data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_log_syslog.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index d1dcf36545d79..a7ff6fdbafc94 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -894,6 +894,33 @@ static struct nf_logger nf_ip6_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
+				  unsigned int hooknum,
+				  const struct sk_buff *skb,
+				  const struct net_device *in,
+				  const struct net_device *out,
+				  const struct nf_loginfo *loginfo,
+				  const char *prefix)
+{
+	struct nf_log_buf *m;
+
+	/* FIXME: Disabled from containers until syslog ns is supported */
+	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+		return;
+
+	m = nf_log_buf_open();
+
+	if (!loginfo)
+		loginfo = &default_loginfo;
+
+	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
+				  prefix);
+
+	dump_mac_header(m, loginfo, skb);
+
+	nf_log_buf_close(m);
+}
+
 static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 				 unsigned int hooknum,
 				 const struct sk_buff *skb,
@@ -913,6 +940,10 @@ static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 	case htons(ETH_P_RARP):
 		nf_log_arp_packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
 		break;
+	default:
+		nf_log_unknown_packet(net, pf, hooknum, skb,
+				      in, out, loginfo, prefix);
+		break;
 	}
 }
 
-- 
2.34.1

