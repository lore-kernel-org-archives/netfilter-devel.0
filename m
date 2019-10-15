Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F22ECE59D
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B48720872
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="R9F0aXjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389607AbfJOVRq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 17:17:46 -0400
Received: from mail-40130.protonmail.ch ([185.70.40.130]:11022 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfJOVRq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 17:17:46 -0400
Date:   Tue, 15 Oct 2019 21:17:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1571174263;
        bh=p3+j7+Gqr/FtOtuL1o9w6KsJVZGnoMhqv1A693If1Lg=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=R9F0aXjDlTxKlPEAs4SpIN6ajfI3Yc5L5Ejh4Kt+nRrmZbMBENF0O2FFTV3CMFkSR
         yRd75dAOOSzcUQ1K9h3+9nWZYlHhnSGVSMH9Xk0Xfh7C3E/VGYis4B9SrxFe24APxl
         lVzswJrd2XW5dxn/Dt+ynxW3OedzdDUD2OgPAx3A=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   a_hungrig <a_hungrig@protonmail.com>
Reply-To: a_hungrig <a_hungrig@protonmail.com>
Subject: [PATCH] nfnetlink_cthelper: make userspace conntrack helpers with priv data work again
Message-ID: <i1P7xDy04ZUlF7D-m77iaXyon7w4xX3QJP3V3QlqUkfqDCVsSMhzty0ILwQ1_78m4FvM7JogSLOnTG-oC2y55dPYZQVo5IyefRDvkr4UI3Y=@protonmail.com>
Feedback-ID: dvT56YDfcW2mtX4j_-_2Gio-2xcuEARDzckO5VNcfcxNhLZ9f3OQrQFdVc7i7WG8Mo1-dohMRoRX7ckPIeMXPg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

had trouble getting the userspace cthelper for ftp working, tracked down th=
e problem to incorrect length and incorrect params to nla_memcpy() when han=
dling the helper's priv data in kernel.

--- net/netfilter/nfnetlink_cthelper.c.orig     2019-10-11 18:21:44.0000000=
00 +0200
+++ net/netfilter/nfnetlink_cthelper.c  2019-10-15 22:00:21.159986725 +0200
@@ -106,7 +106,7 @@ nfnl_cthelper_from_nlattr(struct nlattr
        if (help->helper->data_len =3D=3D 0)
                return -EINVAL;

-       nla_memcpy(help->data, nla_data(attr), sizeof(help->data));
+       nla_memcpy(help->data, attr, help->helper->data_len);
        return 0;
 }

@@ -242,6 +242,7 @@ nfnl_cthelper_create(const struct nlattr
                ret =3D -ENOMEM;
                goto err2;
        }
+       helper->data_len =3D size;

        helper->flags |=3D NF_CT_HELPER_F_USERSPACE;
        memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));

--

Regards
a_h
