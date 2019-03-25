Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63D0C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 18:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B54220685
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 18:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="YuGYwbXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfCYS6v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:58:51 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21012 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfCYS6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 14:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553540324; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=b2A7xMNbfyQQOf+HCwr6VSkYRCQ4OeMmCUnPn0tPoS40WTO/4vFf3nO4rF85m7ZbbMnVNUH/yRPmk5A4YBg8Ar3HlO0gwmjlbC1JRA84FoSaM5U3Pu0gRsdLHxE4oT+mdvvHPRkZn7hNkW5DlsZ7OjGqzpSOIXu8dZFz2mTFSyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553540324; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=m/649Zh+j/IScF5MI9HXrvCcRR+tP7kSKiwVnfdBZ4Q=; 
        b=lWUlaWh6MpSTbNPl+MBJZGPOb528T/IfxXaPUdOXOU8VnUcxyGNGAG3Ke6BhSHWpqnivNmF6bI4R1ksUR3BPFI5HJL7YC70AxK1tcVs/X8Ylr4dX3jQEOvga0u58rfYgAqaz+9zjwSvGS9gQYyqdHSIIdayqr5CM8rln0ImdlMU=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553540324;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1216; bh=m/649Zh+j/IScF5MI9HXrvCcRR+tP7kSKiwVnfdBZ4Q=;
        b=YuGYwbXH36WhozNiuxSBY4WK7ktIHWTGVOPJNC6EBn3sUxSHYqT0SZqwKut01VFU
        olrHfyKzNkco4b5YSeZQp4UUQXPC/Z8OmQbdcoWk0n6JHCGnc5dx8jxJsx1askfDPUr
        P3nKG95CtFDbfuAW8pe5351+/oB8AU4+XOAXGKSw=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553540323039641.4013972572742; Mon, 25 Mar 2019 11:58:43 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190325185831.27284-1-fbl@sysclose.org>
Subject: [PATCH net-next v2] openvswitch: add seqadj extension when NAT is used.
Date:   Mon, 25 Mar 2019 15:58:31 -0300
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
 net/openvswitch/conntrack.c | 6 ++++++
 1 file changed, 6 insertions(+)

Changelog:
v2 - removed nfct_help(ct) check as it is not necessary.

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 51080004677e..845b83598e0d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -990,6 +990,12 @@ static int __ovs_ct_lookup(struct net *net, struct sw_=
flow_key *key,
 =09=09=09=09=09=09=09    GFP_ATOMIC);
 =09=09=09if (err)
 =09=09=09=09return err;
+
+=09=09=09/* helper installed, add seqadj if NAT is required */
+=09=09=09if (info->nat && !nfct_seqadj(ct)) {
+=09=09=09=09if (!nfct_seqadj_ext_add(ct))
+=09=09=09=09=09return -EINVAL;
+=09=09=09}
 =09=09}
=20
 =09=09/* Call the helper only if:
--=20
2.20.1



