Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06008C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 08:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D611660FF2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 08:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhH3IaN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:30:13 -0400
Received: from cloudserver045568.home.pl ([89.161.227.102]:42294 "EHLO
        cloudserver045568.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhH3IaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 04:30:12 -0400
Received: from localhost (127.0.0.1) (HELO v179.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 3.0.0)
 id ccd92027fe4f36b3; Mon, 30 Aug 2021 10:29:18 +0200
Received: from ox-ap8 (v88.ox.home.net.pl [62.129.245.218])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by v179.home.net.pl (Postfix) with ESMTPSA id BAD77B20003
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2021 10:29:17 +0200 (CEST)
Date:   Mon, 30 Aug 2021 10:29:17 +0200 (CEST)
From:   "a.wojcik hyp.home.pl" <a.wojcik@hyp.home.pl>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <680249120.4405960.1630312157715@poczta.home.pl>
Subject: Patch for iptables v 1.8.7 mac extension
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_4405959_1045503916.1630312157714"
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.2-Rev29
X-Originating-Client: open-xchange-appsuite
X-CLIENT-IP: 62.129.245.218
X-CLIENT-HOSTNAME: v88.ox.home.net.pl
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrudduledgtdegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecujffqoffgrffnpdggtffipffknecuuegrihhlohhuthemucduhedtnecunecujfgurhepfffhvffkufggtgfrkgfosehmtdgssgertdejnecuhfhrohhmpedfrgdrfihojhgtihhkuchhhihprdhhohhmvgdrphhlfdcuoegrrdifohhjtghikheshhihphdrhhhomhgvrdhplheqnecuggftrfgrthhtvghrnhepiefgudfgteekjeeikeehveefvdeiieefgfffieefkeetteegffetheejueevleffnecukfhppeeivddruddvledrvdeghedrvddukeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeeivddruddvledrvdeghedrvddukedphhgvlhhopehogidqrghpkedpmhgrihhlfhhrohhmpedfrgdrfihojhgtihhkuchhhihprdhhohhmvgdrphhlfdcuoegrrdifohhjtghikheshhihphdrhhhomhgvrdhplheqpdhrtghpthhtohepnhgvthhfihhlthgvrhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-DCC--Metrics: v179.home.net.pl 1024; Body=1 Fuz1=1 Fuz2=3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

------=_Part_4405959_1045503916.1630312157714
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi.
In iptables version 1.8.7 mac extension sticks words together.
Title: Patch for libxt_mac.c
Description: Extension mac in iptables v 1.8.7 sticks words together
Best Regards.
Adam W=C3=B3jcik
------=_Part_4405959_1045503916.1630312157714
Content-Type: application/octet-stream; name=libxt_mac.c.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=libxt_mac.c.patch
X-Part-Id: dfebedad7f0b427db7e5379b5f76407e

ZGlmZiAtLWdpdCBhL2lwdGFibGVzLTEuOC43X29yaWcvZXh0ZW5zaW9ucy9saWJ4dF9tYWMuYyBi
L2lwdGFibGVzLTEuOC43L2V4dGVuc2lvbnMvbGlieHRfbWFjLmMKaW5kZXggYjkwZWVmMi4uZWI1
NmVkNyAxMDA2NDQKLS0tIGEvaXB0YWJsZXMtMS44Ljdfb3JpZy9leHRlbnNpb25zL2xpYnh0X21h
Yy5jCisrKyBiL2lwdGFibGVzLTEuOC43L2V4dGVuc2lvbnMvbGlieHRfbWFjLmMKQEAgLTQyLDEw
ICs0MiwxMCBAQCBtYWNfcHJpbnQoY29uc3Qgdm9pZCAqaXAsIGNvbnN0IHN0cnVjdCB4dF9lbnRy
eV9tYXRjaCAqbWF0Y2gsIGludCBudW1lcmljKQogewogCWNvbnN0IHN0cnVjdCB4dF9tYWNfaW5m
byAqaW5mbyA9ICh2b2lkICopbWF0Y2gtPmRhdGE7CiAKLQlwcmludGYoIiBNQUMiKTsKKwlwcmlu
dGYoIiBNQUMgIik7CiAKIAlpZiAoaW5mby0+aW52ZXJ0KQotCQlwcmludGYoIiAhIik7CisJCXBy
aW50ZigiICEgIik7CiAKIAl4dGFibGVzX3ByaW50X21hYyhpbmZvLT5zcmNhZGRyKTsKIH0KQEAg
LTU1LDcgKzU1LDcgQEAgc3RhdGljIHZvaWQgbWFjX3NhdmUoY29uc3Qgdm9pZCAqaXAsIGNvbnN0
IHN0cnVjdCB4dF9lbnRyeV9tYXRjaCAqbWF0Y2gpCiAJY29uc3Qgc3RydWN0IHh0X21hY19pbmZv
ICppbmZvID0gKHZvaWQgKiltYXRjaC0+ZGF0YTsKIAogCWlmIChpbmZvLT5pbnZlcnQpCi0JCXBy
aW50ZigiICEiKTsKKwkJcHJpbnRmKCIgISAiKTsKIAogCXByaW50ZigiIC0tbWFjLXNvdXJjZSAi
KTsKIAl4dGFibGVzX3ByaW50X21hYyhpbmZvLT5zcmNhZGRyKTsK
------=_Part_4405959_1045503916.1630312157714--
