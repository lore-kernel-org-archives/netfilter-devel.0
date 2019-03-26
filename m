Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03F9C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA1320700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="C58GsBia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbfCZU6R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:58:17 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21001 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU6Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:58:16 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633880; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=Bq+l9U2WHzPgWd4reTaP6NjV2hMPBqFSMx1pTjoTrOaDpoLBrWrdjZO9Ifnv5uDmxl+QS65LNYLHh6cfUuoy3a4/LCsQquZP6XBnmPGoC5+GyawxqzqhyE2Y7UiHaSE4BcprpLfNjsJR5IoyDMBwu7kZEtdDrxXcjdlf80AUgDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633880; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=G8QQucY9Kz1XJ+21AaQeXMshwUdjgwC5KoHAY8pdQqQ=; 
        b=jWaZH/zWi1b8Cf9q3ZHYDjaF8Yl2nStc8b1hmrCP4XWKbay5lOOVnJWsDTtpsODN4BcggdKDtMMmhuJBuoJiwcp3S6Iel7dxnZDvtVcMFiRjSq777SYtsBvhsbwrFvBzAYNYQIYWfydSBiD+5oCgdze/nsQUjYdpEgX7xtbQCFY=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633880;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=2480; bh=G8QQucY9Kz1XJ+21AaQeXMshwUdjgwC5KoHAY8pdQqQ=;
        b=C58GsBia7jJJpbaZZBcyuQZqiS3PXP2Yj0DYRFFExDTfoAtIVk76wiSLqwX/mvux
        xdaCfpsxGkewiXOuiLmf6ZJjrJGNY6kr+/1tYob1UzHfkY5CMogR5mF3UyURbmJmWtg
        HlQbXdxfndO6QiGwo2JsZmO3uxXJ5sgFxhxOmRKs=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633879367456.6709163022415; Tue, 26 Mar 2019 13:57:59 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-9-fbl@sysclose.org>
Subject: [PATCH net-next 8/8] openvswitch: load and reference the NAT helper.
Date:   Tue, 26 Mar 2019 17:57:15 -0300
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

This improves the original commit 17c357efe5ec ("openvswitch: load
NAT helper") where it unconditionally tries to load the module for
every flow using NAT, so not efficient when loading multiple flows.
It also doesn't hold any references to the NAT module while the
flow is active.

This change fixes those problems. It will try to load the module
only if it's not present. It grabs a reference to the NAT module
and holds it while the flow is active. Finally, an error message
shows up if either actions above fails.

Fixes: 17c357efe5ec ("openvswitch: load NAT helper")
Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 net/openvswitch/conntrack.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 845b83598e0d..fb58637a27c9 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1305,6 +1305,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_inf=
o *info, const char *name,
 {
 =09struct nf_conntrack_helper *helper;
 =09struct nf_conn_help *help;
+=09int ret =3D 0;
=20
 =09helper =3D nf_conntrack_helper_try_module_get(name, info->family,
 =09=09=09=09=09=09    key->ip.proto);
@@ -1319,13 +1320,22 @@ static int ovs_ct_add_helper(struct ovs_conntrack_i=
nfo *info, const char *name,
 =09=09return -ENOMEM;
 =09}
=20
+#ifdef CONFIG_NF_NAT_NEEDED
+=09if (info->nat) {
+=09=09ret =3D nf_conntrack_helper_nat_try_module_get(name,
+=09=09=09=09=09=09=09     info->family,
+=09=09=09=09=09=09=09     key->ip.proto);
+=09=09if (ret) {
+=09=09=09nf_conntrack_helper_put(helper);
+=09=09=09OVS_NLERR(log, "Failed to load \"%s\" NAT helper, err: %d",
+=09=09=09=09  name, ret);
+=09=09=09return ret;
+=09=09}
+=09}
+#endif
 =09rcu_assign_pointer(help->helper, helper);
 =09info->helper =3D helper;
-
-=09if (info->nat)
-=09=09request_module("ip_nat_%s", name);
-
-=09return 0;
+=09return ret;
 }
=20
 #ifdef CONFIG_NF_NAT_NEEDED
@@ -1776,8 +1786,13 @@ void ovs_ct_free_action(const struct nlattr *a)
=20
 static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)
 {
-=09if (ct_info->helper)
+=09if (ct_info->helper) {
+#ifdef CONFIG_NF_NAT_NEEDED
+=09=09if (ct_info->nat)
+=09=09=09nf_conntrack_helper_nat_put(ct_info->helper);
+#endif
 =09=09nf_conntrack_helper_put(ct_info->helper);
+=09}
 =09if (ct_info->ct)
 =09=09nf_ct_tmpl_free(ct_info->ct);
 }
--=20
2.20.1



