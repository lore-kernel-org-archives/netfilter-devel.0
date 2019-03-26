Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A0FC10F05
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D3220700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="AsUT3jtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbfCZU6M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:58:12 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21090 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:58:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633875; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=h5GNb6PJpRr7g2FRN5tRcZh7VFBopn7H9VLGZJJQpE48G9q0BekBT8sLKTGQvZsCbG493Aw+pHWvs6oFXnm5E1Mbf90TSTpmE7ELVzq9cNWjJ3WbM+GGsVpIZ42+wf8wgja6nHsGRMfm+BgE/S873uXilejHqzYl4KzBN4zFo3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633875; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=ih8YfcFgGDhETgyWDDz6NzCR2DlozE6kgWZ8CcCFebI=; 
        b=UdAhmYPQdrsOok3tddl4QOEabXIsyZpce9144T0sbAFFJPc1D6ENAPfcXS7wKYuZL2i29D4UwKHAujCstZK5T3yWLm2S1nJYQrcPAOnXwEiuguE4RwO7CFCXR1uNE3sluRvHa7DvBMtYfz7YHdA2LTVyPUwsywKrkk5ehdg8QAU=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633875;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1284; bh=ih8YfcFgGDhETgyWDDz6NzCR2DlozE6kgWZ8CcCFebI=;
        b=AsUT3jtUqULOUqIp4i+viSDizgq60ap1rz/1Wyq/iqYwa6R2lXuK1zHW6kIkh09l
        zm0ApVTYCBIHbIZKTb+fcwRIUzAAqA0+g+eRs94efspSnFaJeY27nTXVomBDBER9Prc
        dIFFjcU3f++eN8LzpQLtuCUPiRZh5ioAnzQzOV+g=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633875378775.6491236271501; Tue, 26 Mar 2019 13:57:55 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-8-fbl@sysclose.org>
Subject: [PATCH net-next 7/8] netfilter: nf_nat: register tftp NAT helper.
Date:   Tue, 26 Mar 2019 17:57:14 -0300
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
 net/netfilter/nf_nat_tftp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 51673aa6e1dc..5a7af30e3e02 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -18,6 +18,8 @@ MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NFCT_HELPER_NAT("tftp");
=20
+static struct nf_conntrack_helper_nat helper_nat_tftp;
+
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
 =09=09=09 struct nf_conntrack_expect *exp)
@@ -37,6 +39,7 @@ static unsigned int help(struct sk_buff *skb,
=20
 static void __exit nf_nat_tftp_fini(void)
 {
+=09nf_conntrack_helper_nat_unregister(&helper_nat_tftp);
 =09RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
 =09synchronize_rcu();
 }
@@ -44,6 +47,9 @@ static void __exit nf_nat_tftp_fini(void)
 static int __init nf_nat_tftp_init(void)
 {
 =09BUG_ON(nf_nat_tftp_hook !=3D NULL);
+=09nf_ct_helper_nat_init(&helper_nat_tftp,
+=09=09=09      NF_CT_NAT_HELPER_MOD_NAME("tftp"), THIS_MODULE);
+=09nf_conntrack_helper_nat_register(&helper_nat_tftp);
 =09RCU_INIT_POINTER(nf_nat_tftp_hook, help);
 =09return 0;
 }
--=20
2.20.1



