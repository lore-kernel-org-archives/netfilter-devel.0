Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B5CC4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1430A20700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="Qsg8oikb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbfCZU55 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:57 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21055 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbfCZU55 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633865; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=FdcQ3LEkkS40NRDrFE5KfVRS4trKS0Xl49Vvsdzn+W+JkLX26uQ6p+3H8fa8HQYaFTa1+HLBefVJv6nLyB2GkrW8w5zKzJ3ZZKHtgybvroBEcEOclJbhQBipvzT0XpLWtQnRq0f3MrcxAN4VndhRlJb/srnuJNDyVVZ3Xjq0T1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633865; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=J6R9zZ05Q66AkfnJKfT/JAzkD7QhX0GqMJjcriAtjqc=; 
        b=mykDU3oN9tUWS1d+iU6H7oQTA9ANNpCq2ju+I5SzcE5JjvPeQPEJzvtXWfZFwD6QwaJlHalvhlSiekXOPAGI+dCvgfLIJbEwlbo4vuqqOt3AMDc9kxHTJAnLgBHhsP/3kVtjYy2b+nVe3hK1fE5cWD+ad3382KyqLgvYL7+ANb8=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633865;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1286; bh=J6R9zZ05Q66AkfnJKfT/JAzkD7QhX0GqMJjcriAtjqc=;
        b=Qsg8oikbhMgyYLtXxOcNBprsgMhwfPUZNkMKNcclcum2/BSxz0Nq+jwHsZC4ENer
        tOXcR7rfnb9CaqUaICbPan8l10z4iqb2mXGpbO16PmpOX7F7r8IpuPNVN8PODjAwHun
        2PQFxSOUAq2qlnf5JK6WhLblEJ/FtpR201S7RN/I=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633863691345.20847182481066; Tue, 26 Mar 2019 13:57:43 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-5-fbl@sysclose.org>
Subject: [PATCH net-next 4/8] netfilter: nf_nat: register ftp NAT helper.
Date:   Tue, 26 Mar 2019 17:57:11 -0300
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
 net/netfilter/nf_nat_ftp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 19f5739fd5e2..70fddcddad54 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -28,6 +28,8 @@ MODULE_ALIAS_NFCT_HELPER_NAT("ftp");
=20
 /* FIXME: Time out? --RR */
=20
+static struct nf_conntrack_helper_nat helper_nat_ftp;
+
 static int nf_nat_ftp_fmt_cmd(struct nf_conn *ct, enum nf_ct_ftp_type type=
,
 =09=09=09      char *buffer, size_t buflen,
 =09=09=09      union nf_inet_addr *addr, u16 port)
@@ -124,6 +126,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
=20
 static void __exit nf_nat_ftp_fini(void)
 {
+=09nf_conntrack_helper_nat_unregister(&helper_nat_ftp);
 =09RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
 =09synchronize_rcu();
 }
@@ -131,6 +134,9 @@ static void __exit nf_nat_ftp_fini(void)
 static int __init nf_nat_ftp_init(void)
 {
 =09BUG_ON(nf_nat_ftp_hook !=3D NULL);
+=09nf_ct_helper_nat_init(&helper_nat_ftp,
+=09=09=09      NF_CT_NAT_HELPER_MOD_NAME("ftp"), THIS_MODULE);
+=09nf_conntrack_helper_nat_register(&helper_nat_ftp);
 =09RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
 =09return 0;
 }
--=20
2.20.1



