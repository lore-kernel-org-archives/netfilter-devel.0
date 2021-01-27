Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D129EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 14:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12702085B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 14:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhA0OFi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 09:05:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233607AbhA0ODf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 09:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611756128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VRks5p967eXFARcfHyUzeVRONNiZMqvV3SBslsVNlQ4=;
        b=VmZJGkml/afykZNm6b+wxILKtzXqBZsP0ErqVCKlUONb+WXc/sE+2cysd1msrOtSeb+sq8
        cgzh4blwaxaIU1cobXAHAUxE4gzMUTMQ76PtQ8scGtdqcmUebKYCB3fB5n/8DNXwM9ZWYL
        eyT+ttuxgGuC4Bfn0XmIk31UQ8k20oQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-75JuZzfZPaqxXNyhTzEXgA-1; Wed, 27 Jan 2021 09:02:06 -0500
X-MC-Unique: 75JuZzfZPaqxXNyhTzEXgA-1
Received: by mail-ed1-f71.google.com with SMTP id u26so465532edv.18
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 06:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VRks5p967eXFARcfHyUzeVRONNiZMqvV3SBslsVNlQ4=;
        b=SrQB6YiA/5YE1yk9vw1EX9hwrfXryQSZPPPMWhozbwWEoQeopTzT+4w/TKgBTBY/GP
         ZpVPGmLrC3wAIvKMN8Su85MEsfjpqSDa0HNYJIGjN/VI0X5PCfNGZPL6aZgBgU03Gy4j
         XEHtDupqwL1IROlvPNAhkzBRf/ssqCX/Hd+7pT/1CjpPK4XMRSRSKYepYBGQpNdmG7XA
         MA5tMxF7hu4e7qq6wHh8krinAEUwdkMVjpMhiByMthhhCLFXItcWgtd22TBFVVmJCYr9
         54Pj2nSqIU/UhBNXDQ06I3AAGoEk516xVzLeS3R2yWuNjDf6KJz+85oznPA/l41mW7Kn
         zNqA==
X-Gm-Message-State: AOAM532GI6lFiRz+3nh5YNjdeMGdC/ZUW4XPc9pmbF60BRAEC4F8EJyC
        bz3PwIfCMpYZHttXOPq79FPQIiDq3J2PMLY3gHzC0SxBx4W0U/0fkwrG0/rshRSltn6EjAC3jLv
        rjOFlzRXp6s23YdTTwJAYzMq+7Vub7tbqWELNSkmxP+iKzRe8NczQGdYUnkRiKzSnzKMoA4MPh1
        X5SQ==
X-Received: by 2002:a05:6402:94f:: with SMTP id h15mr9015818edz.106.1611756125420;
        Wed, 27 Jan 2021 06:02:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIF2V/jIke8AQGGkgS7arziSenq5WkKcvrEr2Dr1/1YuaDffjrVotvswzsz5Nc/RNYIj5lxQ==
X-Received: by 2002:a05:6402:94f:: with SMTP id h15mr9015791edz.106.1611756125219;
        Wed, 27 Jan 2021 06:02:05 -0800 (PST)
Received: from localhost ([185.112.167.35])
        by smtp.gmail.com with ESMTPSA id g90sm1428715edd.30.2021.01.27.06.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 06:02:04 -0800 (PST)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>,
        =?UTF-8?q?Tom=C3=A1=C5=A1=20Dole=C5=BEal?= <todoleza@redhat.com>
Subject: [PATCH] tests: monitor: use correct $nft value in EXIT trap
Date:   Wed, 27 Jan 2021 15:02:03 +0100
Message-Id: <20210127140203.2099010-1-snemec@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With double quotes, $nft was being expanded to the default value even
in presence of the -H option.

Signed-off-by: Štěpán Němec <snemec@redhat.com>
Helped-by: Tomáš Doležal <todoleza@redhat.com>
Acked-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 5a736fc6..1fe613c7 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -19,7 +19,7 @@ if [ ! -d $testdir ]; then
 	echo "Failed to create test directory" >&2
 	exit 1
 fi
-trap "rm -rf $testdir; $nft flush ruleset" EXIT
+trap 'rm -rf $testdir; $nft flush ruleset' EXIT
 
 command_file=$(mktemp -p $testdir)
 output_file=$(mktemp -p $testdir)
-- 
2.29.2

