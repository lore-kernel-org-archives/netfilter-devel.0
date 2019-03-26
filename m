Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65F3C10F05
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5BC120700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="G7teA0xt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfCZU6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:58:02 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21067 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU6C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633869; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=ZGpr9C+fRFVC/G6waZF0Wxx3Qj7sQCkmsHjco9DS7YEi6NftdPQuiS4jAfz+tdjxtx2cmvUiI/TX71qb/JN4lzs525VSxiG20P2E0dPGiGOPr1xM9v0mWlMjiMwrJsZTv3Xh2QyB35EZ3lKW72eJ6DNhu/EHSeULRkLnQhMpvT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633869; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=4ujUuF389lOnqKY0B6CaQdC6++eiK9827Ee8dTlrYLI=; 
        b=VqvnJQnd7/OjCgdmj8hSPRZ85uYsQKdSHoiGm4bu4blxIXgXNZuRwz+dW7GKV0Qz99YNWxXkbV+6M1UCMDOFPTA7CS2DodJCspiAxz04APTERod6CNSDKntClG0bUUuEf+ovaaJSl/oO/hHZqaxwSDx+zNRJtUYRE2T+DFJlHPc=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633869;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1263; bh=4ujUuF389lOnqKY0B6CaQdC6++eiK9827Ee8dTlrYLI=;
        b=G7teA0xtkTupXufD7lb5qTXwgoSRRAwWtPOl+knUE6CDzruOR6/3pWqBSBdXlTK/
        U8LFJamm2YweGd4BqjOrPSevrrRMGPhEQ5s/opLEJ5tgiflW3qsR6arjU3vjoun8+Kf
        bvPzS5Y8zVriS+ijFrx8xh2L3EfglG+ssuOkJJnM=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633867767240.78749244303606; Tue, 26 Mar 2019 13:57:47 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-6-fbl@sysclose.org>
Subject: [PATCH net-next 5/8] netfilter: nf_nat: register irc NAT helper.
Date:   Tue, 26 Mar 2019 17:57:12 -0300
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

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 net/netfilter/nf_nat_irc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index c18e3ce6589b..853e91c1cea5 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -28,6 +28,8 @@ MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NFCT_HELPER_NAT("irc");
=20
+static struct nf_conntrack_helper_nat helper_nat_irc;
+
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
 =09=09=09 unsigned int protoff,
@@ -96,6 +98,7 @@ static unsigned int help(struct sk_buff *skb,
=20
 static void __exit nf_nat_irc_fini(void)
 {
+=09nf_conntrack_helper_nat_unregister(&helper_nat_irc);
 =09RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
 =09synchronize_rcu();
 }
@@ -103,6 +106,9 @@ static void __exit nf_nat_irc_fini(void)
 static int __init nf_nat_irc_init(void)
 {
 =09BUG_ON(nf_nat_irc_hook !=3D NULL);
+=09nf_ct_helper_nat_init(&helper_nat_irc,
+=09=09=09      NF_CT_NAT_HELPER_MOD_NAME("irc"), THIS_MODULE);
+=09nf_conntrack_helper_nat_register(&helper_nat_irc);
 =09RCU_INIT_POINTER(nf_nat_irc_hook, help);
 =09return 0;
 }
--=20
2.20.1



