Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FEDC10F05
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54BD320700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="QTtviprO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbfCZU5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:41 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21034 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU5l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:41 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633853; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=RhQWLO3T4u4ndOJBmzpTAnEAM9KrqYP9+FGbdQEgjdUmgNTclRFbJWyLjiAXMqJNrN7xE7ApLJGTnysqnPjwsO9wSjn0j9W0rCzLEOsqZRBye53wsU6WbQ/EAHmAhvzU78xezZt7G3XmNShsHz0xEv7IU8CRPoZ67TVc7ek9tWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633853; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=gbK3oRcV1+O/l27rLJlwgzN3TUvSMaSvpnfknpakots=; 
        b=Bl7jS3hCT/s5AzsASU+EHBMy5AXd/OmPRuMG4nAtomg6SJ3qaf4ZWlncSsKjW7xPRdF+e1Ee++kcxT3drP1ER/yoBGOaKhWC54c4Veae3POa34dEnXqxS+lcMkEXDw549YVXCC/KsO45Mbfe7XmTRv7Tp9US4Mv4BOpaT5CVXNs=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633853;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=4532; bh=gbK3oRcV1+O/l27rLJlwgzN3TUvSMaSvpnfknpakots=;
        b=QTtviprOw+PM5Cyhk+95lYsGCek+RhmEVs7qbjK9XZjdBVx6kfRxc/4lWPJTIysL
        jqtvzRRq6LSYcR9HsSc3bar8VTAJVR1n7GxwNIDhYAh1j6q1U9VNqIB18TPXeM8EGYi
        YIeGTrbP7uzJGe7/KnL6CUgW3u2OgsWvmD7b9920=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633851785306.0051481156381; Tue, 26 Mar 2019 13:57:31 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-2-fbl@sysclose.org>
Subject: [PATCH net-next 1/8] netfilter: use macros to create module aliases.
Date:   Tue, 26 Mar 2019 17:57:08 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326205715.22288-1-fbl@sysclose.org>
References: <20190326205715.22288-1-fbl@sysclose.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each NAT helper creates a module alias which follows a pattern.
Use macros for consistency.

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 4 ++++
 net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            | 2 +-
 net/netfilter/nf_nat_amanda.c               | 2 +-
 net/netfilter/nf_nat_ftp.c                  | 2 +-
 net/netfilter/nf_nat_irc.c                  | 2 +-
 net/netfilter/nf_nat_sip.c                  | 2 +-
 net/netfilter/nf_nat_tftp.c                 | 2 +-
 8 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netf=
ilter/nf_conntrack_helper.h
index ec52a8dc32fd..e86fadf7e7c5 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,6 +15,10 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
=20
+#define NF_CT_NAT_HELPER_MOD_NAME(name)=09"ip_nat_" name
+#define MODULE_ALIAS_NFCT_HELPER_NAT(name) \
+=09MODULE_ALIAS(NF_CT_NAT_HELPER_MOD_NAME(name))
+
 struct module;
=20
 enum nf_ct_helper_flags {
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h=
323.c
index 4e6b53ab6c33..09754e787692 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -631,4 +631,4 @@ module_exit(fini);
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
 MODULE_DESCRIPTION("H.323 NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_h323");
+MODULE_ALIAS_NFCT_HELPER_NAT("h323");
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_p=
ptp.c
index 68b4d450391b..1a984e5db88a 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -37,7 +37,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
-MODULE_ALIAS("ip_nat_pptp");
+MODULE_ALIAS_NFCT_HELPER_NAT("pptp");
=20
 static void pptp_nat_expected(struct nf_conn *ct,
 =09=09=09      struct nf_conntrack_expect *exp)
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index e4d61a7a5258..e87075763f73 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -22,7 +22,7 @@
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_amanda");
+MODULE_ALIAS_NFCT_HELPER_NAT("amanda");
=20
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 5063cbf1689c..19f5739fd5e2 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -24,7 +24,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
-MODULE_ALIAS("ip_nat_ftp");
+MODULE_ALIAS_NFCT_HELPER_NAT("ftp");
=20
 /* FIXME: Time out? --RR */
=20
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 3aa35a43100d..c18e3ce6589b 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -26,7 +26,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_irc");
+MODULE_ALIAS_NFCT_HELPER_NAT("irc");
=20
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aa1be643d7a0..f31c2a1b95b8 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -27,7 +27,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
-MODULE_ALIAS("ip_nat_sip");
+MODULE_ALIAS_NFCT_HELPER_NAT("sip");
=20
=20
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protof=
f,
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d5310d..51673aa6e1dc 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -16,7 +16,7 @@
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_tftp");
+MODULE_ALIAS_NFCT_HELPER_NAT("tftp");
=20
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
--=20
2.20.1



