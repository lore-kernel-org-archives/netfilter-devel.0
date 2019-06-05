Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7677CC282DE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4A0520717
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLMuWcvi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfFEJag (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 05:30:36 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:35982 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfFEJag (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 05:30:36 -0400
Received: by mail-wr1-f47.google.com with SMTP id n4so15674432wrs.3
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2019 02:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UoIy754lljiwmFhdrsb+i++JYA9btYdecZ1OGaoik/Q=;
        b=vLMuWcvih1HfgBJEoyZ0y88F+VjKtpJDJ+zNjoYWBd1wM3jhndxVsETw1wNHpT8xX8
         TwL1a+cgEiE7cyj4noe2CtNPJ+Dvg7AaBO4jnGIbqr5wowUJYA94QcGaQEBmtF8oZ0j2
         WsBP2tsu11QCcgkI5G8kPQfoLquCVtf5slJIGyjj4cOM/JXULhDnNP2G8nxRbbsAQ5mG
         sMf5NDxEMCE0JKIIITh/HjxRE/FJY/IaMVyAimUr20hVzTZ54sZ3ZpdXULdmvA2w9wsl
         exIdomN9XgZq67ukWosTx9fFmQlT8lnU86vv/uQax84XkGJAEkKKrUKhk+blFl56FVnh
         x65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UoIy754lljiwmFhdrsb+i++JYA9btYdecZ1OGaoik/Q=;
        b=K9dVjdos9UFv/0mByP00+o4gcSCpm03UUx2u/H9AH05Xgk/7hYEAFUFrpKlkDT/1VN
         8CChv5A8fRKUnMg9AqfzCrNMLbJrHFcCU2xFaaMlFc6akHJfhUe82AKiQabyNKIUZGA9
         wVHBGR3GBoPZ/kzKhM/2JMIQz5f4FPvE/lIRtrkE8bnsf0aG5TZw10j5a1ZQ0TQM5Vvw
         3ud/IwJ3TzMMBpfu5QnkilY1lTkLBysTLZ1kvFBWBKY0vpbCM7wEZWJV1JvYBjtCxQW7
         H5rscELuaKyIlfHUx6e9d/hjXTrMO0KwNeDbDcGt9pGIw/nA13z6kHi2i8d3szWDYnSq
         48/w==
X-Gm-Message-State: APjAAAU8ZUd3xV4eSlooIyW2m5gzWD7Lyk2DP4UK1KO2bNdxsiTbWTVm
        D9kDcltlYvv5LxJ1z3hjFvIMdc+2
X-Google-Smtp-Source: APXvYqxaSJq5f75/J2rs6lhHudSdCz0vCmiFpnNWQnft7c/1hkyNTJWsLqdhXhMSMS49t7dOCNX8yg==
X-Received: by 2002:a5d:4849:: with SMTP id n9mr1798342wrs.139.1559727034566;
        Wed, 05 Jun 2019 02:30:34 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id t14sm21313736wrr.33.2019.06.05.02.30.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 02:30:34 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nftables v4 0/1] add ct expectation support
Date:   Wed,  5 Jun 2019 11:28:17 +0200
Message-Id: <20190605092818.13844-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the nft part of the modification to add conntrack expectation support.
This is following the nf-next and libnftnl parts.

Stéphane Veyret (1):
  add ct expectations support

 doc/libnftables-json.adoc                     | 55 +++++++++++++++-
 doc/stateful-objects.txt                      | 49 +++++++++++++++
 include/linux/netfilter/nf_tables.h           | 14 ++++-
 include/rule.h                                | 10 +++
 src/evaluate.c                                |  4 ++
 src/json.c                                    | 11 ++++
 src/mnl.c                                     | 13 ++++
 src/netlink.c                                 | 12 ++++
 src/parser_bison.y                            | 62 ++++++++++++++++++-
 src/parser_json.c                             | 45 ++++++++++++++
 src/rule.c                                    | 35 +++++++++++
 src/scanner.l                                 |  1 +
 src/statement.c                               |  4 ++
 tests/py/ip/objects.t                         |  9 +++
 tests/py/ip/objects.t.payload                 |  4 ++
 tests/py/nft-test.py                          |  4 ++
 tests/shell/testcases/listing/0013objects_0   |  9 +++
 .../testcases/nft-f/0018ct_expectation_obj_0  | 18 ++++++
 18 files changed, 354 insertions(+), 5 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0018ct_expectation_obj_0

-- 
2.21.0

