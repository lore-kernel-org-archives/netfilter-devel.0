Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhLQIDo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhLQIDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:03:44 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F097C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:03:44 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r138so1369351pgr.13
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mlDa/qmsf6aAZXjcxYcE/99v/Wcu2dwRT3Oera73UeU=;
        b=BRSiaBipgZPaPSVeKlfauNsUm0H2Cak/LZFKZhFw0LKQKMulmvgpgMDCC/QRoGh1qF
         nyBswc7QUJCG5w2QCELDSDipjDHUiyHa4nTPTt+6/92IB9lqP6ifyqEmIoyfrWbLKy42
         1vj7hbLqX3ARNgQhF9f64ty8mgl8JvsxmbYVuAla6D5CDnG4xmQVxDSaArpuRgW1ZKzv
         hqn9TbfIsEsb0qR6DwVIKtLBs2/lOxFAbpY0+vox2tVC4Qgq0lKTEe/v/FkYNEVGnTpm
         R7/Vh48j1ek/iQF2Wou5K2z09ZnS6Bgau6Z0mnMlgSzBqpmWYtRmjmPnc7go/ZTBefQO
         6biQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=mlDa/qmsf6aAZXjcxYcE/99v/Wcu2dwRT3Oera73UeU=;
        b=pNzY7cnyEjA3o6+WP7REQqS4OsWoUQ15Y6QEI1BLPnj6hOr8Lhq+pWaNyuyRv14RRH
         ujqKKY+HMGEZi/W5RJBoffMercjUsyLHljphyYLZW0qyZnPYnRV2JM3HsMPPp9t8bOLQ
         VQw4JtNaCKWtLrg06qnFk7KToVum993rTEMTUFnU5Oln11lsDCSsNzmZxfEP+us9tKD9
         wIxclMeD6OZnxTH4tnfDONnXA+98dkOyDVLbc9LZH5a9h1GTXqD1TsIN47MvxrDOrSNO
         X45K6vJ8w20plqpHfCLfVeM1cRxdSp060XEymSBn5sip4+3Cn/POE3F77n81NnhrC30/
         69Dg==
X-Gm-Message-State: AOAM531i0wAejmqL1FyuRmNOiclL74oGOv34bomfgwrs2Rt+Ckj8Zred
        50rF+gMCxK0IaQijhJj99G4=
X-Google-Smtp-Source: ABdhPJxaLtwmF3rDR0bQSkOzpvKWwFv/L4woF7E2HbVxCUEg6+nq/8K3j/jIFl8xsau/rGf6NjbuhQ==
X-Received: by 2002:a63:180b:: with SMTP id y11mr1895347pgl.317.1639728223835;
        Fri, 17 Dec 2021 00:03:43 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id mu4sm12399146pjb.8.2021.12.17.00.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:03:43 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] build: doc: Update build_man.sh for doxygen 1.9.2
Date:   Fri, 17 Dec 2021 19:03:38 +1100
Message-Id: <20211217080338.23844-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Function del_def_at_lines() removes lines of the form:

  Definition at line <nnn> of file ...

At doxygen 1.9.2, <nnn> is displayed in bold, so upgrade the regex to match
an optional bold / normal pair around <nnn>

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 852c7b8..c68876c 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -96,7 +96,7 @@ fix_double_blanks(){
 del_def_at_lines(){
   linnum=1
   while [ $linnum -ne 0 ]
-  do mygrep "^Definition at line [[:digit:]]* of file" $target
+  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
     [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
   done
 }
-- 
2.17.5

