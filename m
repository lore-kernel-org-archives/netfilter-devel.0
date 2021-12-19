Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745C6C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Dec 2021 01:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhLSBJn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Dec 2021 20:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhLSBJm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Dec 2021 20:09:42 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58B6C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Dec 2021 17:09:42 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p18so5091118pld.13
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Dec 2021 17:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26H2gfhpoZo8RHRYLvcQVw0lGe8BGuGuANeyM6K4nPg=;
        b=QWYs8N/92/k18Gdet1ob8EBJQ4a6qbkqj15M8oVqe7VUnWDXZQJDqbJSN6ogq07kJo
         pcWS2jYwtRONWCeA0nHQ6fP4nvQbEgn+Z2N7I2BckgnY76smnEpe8Q/jVd4Bnpc6pwJ+
         Ib9G7gXZziCgbpd/4XhzJHgEhqrJGh9ZkNDrA+wMZ28DGFuC/4ip2IkcYchCc7SDSgK+
         Z4rnMy2cjJnVjhWykrrwngYLmopAif0332mPz+c3307RjiEZOmYOYzAwnPl0RTag2h/A
         k2soZcYiZ9/3ck+kF3aSRVeefvPGH7cUFFbC/fyutv9PIuZYqshOBsh3+aX/iVIWNSNO
         xBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=26H2gfhpoZo8RHRYLvcQVw0lGe8BGuGuANeyM6K4nPg=;
        b=TcJpjikh4HogFVksTPMn4a1nfgfXggMfpqVbdLJ8JAOoTRyJpTJTw87bqhKIaqxW0g
         rALFvNncV76fLPFW5zz6VTY6AqwhyOr3ZmGXKGu/9WW1SYc4CMPP8Bzft6z7L37QaKir
         wsCcwYJHvuxlFUbYezWKOBnYlcfZQJeSsNIq9eXSwe4hNgpTN/DsTL5nyr4ZbgVKNayh
         /aHfHwDdViDB56cDzBTfPXKI+NwRGahjnl4c8152pbIGSiIfkn4zD1LpOI7iUEy79rI5
         8bWDAelXjjvPRPz4MZwygjdDBP5EWNkbLtLYW2ZEnjb9zz+kCpDNqBtbk/oru9c8zF8c
         nn5w==
X-Gm-Message-State: AOAM530/9YgIBTTFpTlHUYLS7Q15qzlvgiNBuQOb4bBLbaH0WpASjymQ
        hPDbMOml2Pzc8U1KEuZuDXA/dLEiX+w=
X-Google-Smtp-Source: ABdhPJz5gwQf+hn7WhCGRCbMrnS6anPcUA1PfmVybPE4K2Nv9zIK2sNZSR2f8XiChj0hDh7E8h71UA==
X-Received: by 2002:a17:903:2304:b0:149:1c:154b with SMTP id d4-20020a170903230400b00149001c154bmr2089516plh.100.1639876182113;
        Sat, 18 Dec 2021 17:09:42 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id g1sm13436476pfu.73.2021.12.18.17.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 17:09:41 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3] build: doc: Update build_man.sh for doxygen 1.9.2
Date:   Sun, 19 Dec 2021 12:09:36 +1100
Message-Id: <20211219010936.25543-1-duncan_roe@optusnet.com.au>
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
v2: Expand commit message as pablo requested
v3: same as v2 but has these vn: lines
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

