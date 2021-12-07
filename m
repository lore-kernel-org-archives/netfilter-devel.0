Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCE4C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 22:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbhLGWsj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 17:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbhLGWsj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 17:48:39 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3588BC061574
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 14:45:08 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso623050pjb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Dec 2021 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=depmTnIrNk9SyX8dbaCC/ylgOJJijpSUSW+aiL3QjI0=;
        b=f20zwM1d5hHmU80E7HT7c7SjXVvDrngPkmm2jFQpR9TRNmY9qzZ0ibkRkgiuQjjr58
         VnG4EG6B3K7yseFZoIaJe8tqRUNdfYBMZQxu/JQP7H/8LpQRc6u+J1fJv9ivVJOzAjPD
         +xj3Ro8i8TpUMl8y555F1KMcqPWCoTAYPK0Ymbd+107/3sCP0oGoT9nGPVVtBgpHe+Vv
         UVP07YV8PRVURIBuh5RJ6sFKKs1ZDGjttJgthjYI8wgFEuafd02uAW59DCBbllRrzc51
         Ne4zNQWuJU/UMb3kKN/z3FSG/OoyubWcf6rAtlBsPh2wZkrv3fh38JpgWX1lKqc1B48C
         iq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=depmTnIrNk9SyX8dbaCC/ylgOJJijpSUSW+aiL3QjI0=;
        b=VrXNuIEz+/KmV0sBm9Hx3JScYLyMIYvGYEq9wRezJUQ9Jfw5E44hdutkWEpTUaN8Ou
         yKISj3sjnHoUgk9mNu5Xu0TB1J6q8GYm4HNcqtFLu3XPc2sh8tbWUMotTCFPTDOOqOJv
         ZilG9isD80GVrb/6sBVlxClasqbLQQutO3/Ct6DjfYr0zUMVE/qZu3X7U0gfNjBuc/sr
         8GPyjojcyYvy8i24OcIxsT5b5m6+ZbFx9YGx3HJBQsCQMP/b1gUWxaJCw7p9G8a06XmG
         L1BampKZWvj2v9IF7YcUMlOpEFGrtHIi3krP1mdrjqWquWKLR8L/8rXtIqNVn1iYJKAN
         bXyw==
X-Gm-Message-State: AOAM531tgY3oz/2nmxIhacrl/m5SeRxKo0mXdH4mIPq+EL4QZ0qVeuRm
        ERdSMtk17Y5YNppfaIicuriZa2gcUJ4=
X-Google-Smtp-Source: ABdhPJzrtgyW6kEsS8jx3ryTwhVf4oA8qmB4pByw1LUCZBJSunk6y3Sjl8X6cYumx4O+hBy2FN6L0A==
X-Received: by 2002:a17:902:e0ca:b0:143:c213:ffa1 with SMTP id e10-20020a170902e0ca00b00143c213ffa1mr54654349pla.73.1638917107801;
        Tue, 07 Dec 2021 14:45:07 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id h128sm756580pfg.212.2021.12.07.14.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:45:06 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Update build_man.sh for doxygen 1.9.2
Date:   Wed,  8 Dec 2021 09:45:02 +1100
Message-Id: <20211207224502.16008-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cater for bold line number in del_def_at_lines()

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

