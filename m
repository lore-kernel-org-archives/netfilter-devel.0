Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8114EC4360F
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 17:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4772E218B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 17:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="EoC30xW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfCURHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:07:47 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21115 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbfCURHr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 13:07:47 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553187158; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=V638s5qmGeLcg905Gk9YAwE27QzkWiqimTiVqCTLGhA3V6Y52CqZOtzZbbZWIq9jTdHYTYeThqeD634ZTozlSpU2f5rF5X4V52/J4QLaVUMssU9SrAEDXaOrzrxuhw6Sn3I3yOhLV6b9EzdZRD7hezim8DAZ0+IAcFB2blx0Gd4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553187158; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=k1w7AneCs7Lpa7K1NslS67ZjNJ2nvBKTzifJTz3cbfs=; 
        b=QS2HOaOcGcghXoD28p3OhdpKzs4IkkqZ3bz9EyPYPlmld+HrG+5kw5MVBArSQEpFAWMXwk56ny14xcUanVuwYkrfxUsyhnV5ZpYEUXKNVVcxPZH2u89VTo48NqRK7CCbvAip2Juub+SRv2RU5rlpKMUlKv+f9LKbn6EKNyFMmYc=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553187158;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1095; bh=k1w7AneCs7Lpa7K1NslS67ZjNJ2nvBKTzifJTz3cbfs=;
        b=EoC30xW26Pe+smxq/gpAOJKGeQ1lCizRgrPaDEj3o+5exKsL2wp7t4Qcb2xvGz3B
        xm8pO0LeTg2uL5plzkXmjRlertlT9iTYIckYjr1ssDvm1ADLBBsn9Z4XR8JNgkwWpDc
        7gZdGEo9oHyHN5hl6JhPbHR7NUpP9XfX9ZHoPQBY=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553187156800299.83666554707395; Thu, 21 Mar 2019 09:52:36 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190321165224.24118-1-fbl@sysclose.org>
Subject: [PATCH net-next] openvswitch: add seqadj extension when NAT is used.
Date:   Thu, 21 Mar 2019 13:52:24 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When the conntrack is initialized, there is no helper attached
yet so the nat info initialization (nf_nat_setup_info) skips
adding the seqadj ext.

A helper is attached later when the conntrack is not confirmed
but is going to be committed. In this case, if NAT is needed then
adds the seqadj ext as well.

Fixes: 16ec3d4fbb96 ("openvswitch: Fix cached ct with helper.")
Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 net/openvswitch/conntrack.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 1b6896896fff..a7664515c943 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -990,6 +990,11 @@ static int __ovs_ct_lookup(struct net *net, struct sw_=
flow_key *key,
 =09=09=09=09=09=09=09    GFP_ATOMIC);
 =09=09=09if (err)
 =09=09=09=09return err;
+
+=09=09=09if (info->nat && nfct_help(ct) && !nfct_seqadj(ct)) {
+=09=09=09=09if (!nfct_seqadj_ext_add(ct))
+=09=09=09=09=09return -EINVAL;
+=09=09=09}
 =09=09}
=20
 =09=09/* Call the helper only if:
--=20
2.20.1



