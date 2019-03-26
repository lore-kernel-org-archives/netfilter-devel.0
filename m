Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA925C10F05
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A3D20700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="ee++TOdM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732843AbfCZU6I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:58:08 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21083 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU6H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:58:07 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633873; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=j5To2kw1MjWBHA3IxGB0kehE322N7kLAjSp0tQxunzGa1pw9+z/YKLN7tUGMjgN3+OlkyLO21uwWfU5gvkxK3fvmJinQk2IH7Id/LBFGuKCSrF7k5B0CFaJQqfuOpcK55SovNQYk1S+SitIcEmCNxKDnjDraYRGqwCGjmhuWz7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633873; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=TAru2jTqEEdhkxlmEsmL5fYFWp3aX2q1v2JEALqHOEM=; 
        b=avfVa+MTDEDb2HTve0L3bBeB4Pymy9j9RXhC66ZBGlNfj/S0/ukJbnfIsOmS17QSvbFNELWzph/V/52sJUwchcgZiifVrSmAFDKF6Y9eM0O7ubo5GBBzUjJKWwEEHMOGgWbkoBAuJponkbQnpegJtvHsuXen7cMSAsOjq0ElvbE=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633873;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1434; bh=TAru2jTqEEdhkxlmEsmL5fYFWp3aX2q1v2JEALqHOEM=;
        b=ee++TOdM75WOmLdlQyf4bFa1jaKNY0ZVTmwe4YKQJakIDG94K4O1SCnvFQYiCXbc
        FizxmtylRNt894T159RC1vbw984fGJoeOeismmfF5RAjaI+8yOqx351ChQCZNNGI/r6
        OAF8Lcd3CilDbrUx78zF0xfqdivNjD9UEk2leryc=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633871652592.329257973618; Tue, 26 Mar 2019 13:57:51 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-7-fbl@sysclose.org>
Subject: [PATCH net-next 6/8] netfilter: nf_nat: register sip NAT helper.
Date:   Tue, 26 Mar 2019 17:57:13 -0300
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
 net/netfilter/nf_nat_sip.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index f31c2a1b95b8..42b3d2e7ecbd 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -29,6 +29,7 @@ MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.=
ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
 MODULE_ALIAS_NFCT_HELPER_NAT("sip");
=20
+static struct nf_conntrack_helper_nat helper_nat_sip;
=20
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protof=
f,
 =09=09=09=09  unsigned int dataoff,
@@ -656,8 +657,8 @@ static struct nf_ct_helper_expectfn sip_nat =3D {
=20
 static void __exit nf_nat_sip_fini(void)
 {
+=09nf_conntrack_helper_nat_unregister(&helper_nat_sip);
 =09RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
-
 =09nf_ct_helper_expectfn_unregister(&sip_nat);
 =09synchronize_rcu();
 }
@@ -675,6 +676,9 @@ static const struct nf_nat_sip_hooks sip_hooks =3D {
 static int __init nf_nat_sip_init(void)
 {
 =09BUG_ON(nf_nat_sip_hooks !=3D NULL);
+=09nf_ct_helper_nat_init(&helper_nat_sip,
+=09=09=09      NF_CT_NAT_HELPER_MOD_NAME("sip"), THIS_MODULE);
+=09nf_conntrack_helper_nat_register(&helper_nat_sip);
 =09RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
 =09nf_ct_helper_expectfn_register(&sip_nat);
 =09return 0;
--=20
2.20.1



