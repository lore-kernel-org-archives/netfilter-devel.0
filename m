Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E1C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3086C26C8E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5VBQURz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfEaQxw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 12:53:52 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35299 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaQxw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 12:53:52 -0400
Received: by mail-wm1-f47.google.com with SMTP id c6so3438393wml.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 09:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P3CbsISNalkLqLLFYYuknUSWpeFCoj1SwnvBT24aHBo=;
        b=a5VBQURz5KIgH5pFHHLGFNUYDAphZEdkeKEg++a50bh7aZ3WRBj4R0IICvGCEZ6gpb
         0X5QLA8EQOintcuw2PGFkJ26+i6ihhiY29nRHX11qeaj5A02Z2wX5IXToUMZUhR1wEHZ
         W6+h6K4kJzXHTzJHa0NpXj9WoGzRhbmOc3+ug+uvm8j3UUtMslMcj9tOEL+aN+iDN8La
         8/4tpgZCZinbT1X2FMsH/zJIoUghX+nKJDW/fPj1ou0O1nNxQ/h57SJ6O2J8ybYw8hMW
         7T6rCiGBjyr9Zv5jsswJcGXjQGTtNc12iR+8v7Yb9KslJui9Wk0OorDOKIvGtUit6AzZ
         4AGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P3CbsISNalkLqLLFYYuknUSWpeFCoj1SwnvBT24aHBo=;
        b=dcd/NJOf3cCTugAzzTTL1T7kafSxnOcHpja+4G2F+pa9oLkOS3ThJloXSMlrQAWCAp
         lDtrfyHTkyj7frjL+bmubZSv2fsDd34ITu5jiMHoxcCEUSTC3kMhN4RKLxUuW0+7PryG
         SRsKlHckxtUwUE0E83fqeFsWZ2cpqD4lDKG9s5mvNgwYVGKF/lpXxXPkuulyVWWlJseC
         ujSNWmE+j1MhxunAK73lajysJ4yByMdaX0oujWkDjoJeq3Eg7vD8K+ehGaryoQLKBW5u
         xoz8IskP1fDYFbt/owjKUs4mJeki9wk1I9quxxc8hILFnROfM1fwIc9ebTtP9blJ7gM4
         aFbw==
X-Gm-Message-State: APjAAAUSyJJJvCMtlKLtgrsjoP6wIqEZf73Vacsz5/OEW8BBZRUvyXKh
        dJrZdUas63n7aTOUZoSE6VDgkJbC
X-Google-Smtp-Source: APXvYqx9e2S/TX4+8pGk5DqxXGMdjL+GYOW4ElDEo/uW9ooVfFCB4Wq0F20o6jDnB7BfBCrMZ0yGxw==
X-Received: by 2002:a1c:ef10:: with SMTP id n16mr5930274wmh.134.1559321630234;
        Fri, 31 May 2019 09:53:50 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id f24sm5066829wmb.16.2019.05.31.09.53.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:53:49 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH libnftnl v4 0/2] add ct expectation support
Date:   Fri, 31 May 2019 18:51:43 +0200
Message-Id: <20190531165145.12123-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please find here the second part of the ct expectation support.
When needed, please ask me for the third part: nft patch.

Stéphane Veyret (2):
  src: add ct expectation support
  examples: add ct expectation examples

 examples/Makefile.am                   |  16 ++
 examples/nft-ct-expectation-add.c      | 153 ++++++++++++++++++
 examples/nft-ct-expectation-del.c      | 126 +++++++++++++++
 examples/nft-ct-expectation-get.c      | 142 +++++++++++++++++
 examples/nft-rule-ct-expectation-add.c | 163 +++++++++++++++++++
 include/libnftnl/object.h              |   8 +
 include/linux/netfilter/nf_tables.h    |  14 +-
 include/obj.h                          |   8 +
 src/Makefile.am                        |   1 +
 src/obj/ct_expect.c                    | 213 +++++++++++++++++++++++++
 src/object.c                           |   1 +
 11 files changed, 844 insertions(+), 1 deletion(-)
 create mode 100644 examples/nft-ct-expectation-add.c
 create mode 100644 examples/nft-ct-expectation-del.c
 create mode 100644 examples/nft-ct-expectation-get.c
 create mode 100644 examples/nft-rule-ct-expectation-add.c
 create mode 100644 src/obj/ct_expect.c

-- 
2.21.0

