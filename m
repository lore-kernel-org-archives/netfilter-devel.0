Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5BEC4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 598CB20700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="ZH15r7Tw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732811AbfCZU5x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:53 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21049 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU5x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:53 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633862; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=FLk8JtK/xCESA3ttOF+m6FYVW4F4VhaMBmyuzuhFvFHu+w5bMCO5L8xdBYmBvLN0U2CLBQTP6POXk9pRgZOocFqQcLG+UubNATudhRPqpyF+0fl5cmwS4Rp5d7ocIssembhCRN7sjHJ3PtEjuD59PTrro+V3EliO6uORbGKVXqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633862; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=RdX7ooXWtC5qFGmUTdLbejQooqCsggbQuPGxptJT6+U=; 
        b=bYjnDNhCNsQRRoTFrQah0Sc1GBa40A4kFEvYLnCedeWFpkob6vnodhBDbyYdEzmcGaExSaFOM+TRLIfepoNHWNfWI6jz537X4CYSpOcN7i81GVzmgxmcjOWWStbnaq1fpToBvaf22EAV4e+hXgCthFwRQpUKOzfrhncM44Em/kA=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633862;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1323; bh=RdX7ooXWtC5qFGmUTdLbejQooqCsggbQuPGxptJT6+U=;
        b=ZH15r7Tw+CbgUUmHFf2KhIAFnpTEulTfn92e/gJgzjh+HXdvXKQWvc99hLLwOXOm
        2gvfcBvCTfNK0ccFxgX1p8blnYTc5eSYIlhaSHc6dc9Hmfw7olCqD06NrtdMtksO0x8
        HF0IjpGnaV1wD0lb9nROL+9qZeNUhS8NjA/oRo2o=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 155363385995557.87658927428356; Tue, 26 Mar 2019 13:57:39 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-4-fbl@sysclose.org>
Subject: [PATCH net-next 3/8] netfilter: nf_nat: register amanda NAT helper.
Date:   Tue, 26 Mar 2019 17:57:10 -0300
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
 net/netfilter/nf_nat_amanda.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index e87075763f73..344096418224 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -24,6 +24,8 @@ MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NFCT_HELPER_NAT("amanda");
=20
+static struct nf_conntrack_helper_nat helper_nat_amanda;
+
 static unsigned int help(struct sk_buff *skb,
 =09=09=09 enum ip_conntrack_info ctinfo,
 =09=09=09 unsigned int protoff,
@@ -74,6 +76,7 @@ static unsigned int help(struct sk_buff *skb,
=20
 static void __exit nf_nat_amanda_fini(void)
 {
+=09nf_conntrack_helper_nat_unregister(&helper_nat_amanda);
 =09RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
 =09synchronize_rcu();
 }
@@ -81,6 +84,10 @@ static void __exit nf_nat_amanda_fini(void)
 static int __init nf_nat_amanda_init(void)
 {
 =09BUG_ON(nf_nat_amanda_hook !=3D NULL);
+=09nf_ct_helper_nat_init(&helper_nat_amanda,
+=09=09=09      NF_CT_NAT_HELPER_MOD_NAME("amanda"),
+=09=09=09      THIS_MODULE);
+=09nf_conntrack_helper_nat_register(&helper_nat_amanda);
 =09RCU_INIT_POINTER(nf_nat_amanda_hook, help);
 =09return 0;
 }
--=20
2.20.1



