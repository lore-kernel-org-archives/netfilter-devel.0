Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F80C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 00:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345854AbhLAAnF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345842AbhLAAnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 19:43:05 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48937C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 16:39:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q17so16281804plr.11
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 16:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xV6vYqcriY5qonQ+tIAHfsi3FzhhwwunDE/Xz/5fCxY=;
        b=CSCpt51DJFdBGtlwWNoMNkqOOgRD4/e/VCKsomKo50O3HVLhCdiMCvH/SzD4U1OJvU
         GQedG6YzwWHoixBY8vPWbAX5A0JUNY8qqwi3OGmzzrDwBTFFjVBmxYJuNoTuvLsyS1Rm
         Y+Pq42nvFC7BtkZ4KR1BR7uG4PawRcZLMdEFE9+OhJ3zJCQtNu0PSZoE6iLbtK/Y/A1U
         nTs5nqOeile7WGGSdP6fqy7x+fP7H43yxsGuWchrq20T9ztOsmE1tHmgMOSIjsHJ2Dhh
         cd3N875VVtYobwb5Cdz9ibrsEPbfn/SmhzUoOrfp3xhn3HctDvFZQ3l13AGgRS+hUz4F
         3XIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=xV6vYqcriY5qonQ+tIAHfsi3FzhhwwunDE/Xz/5fCxY=;
        b=yRb69HaAMJgJdT6Az9phQjVPL7DvTLLPHbkd3DllNibW5JTwFhqqPAgi5VgJiCfl/0
         ODQ3OB1eKiGv0Lr9+W/BJUj+vbs1qw4UiqYM61mirzJaqmQ2c3gC/ruendbb/R3QUcDB
         NwOVOziYAl4aRSOUazjhtmvtmEN4cppIRTvdmnyxe6FnLXSkzgGEUlhbE30hGHk6Nykm
         PcIgI41ClbBfBrf6wD9vjz//8blaKsKtcXVOlCMi2c+EtvTodPNzWwdRbwDO9ZdE0PrP
         4FldHuu3EonvAvqJHHlJlFEAO2GLo884JaGBngYfK+LN+wc+qKr/CNjuGpDULcEzKcUj
         DGOw==
X-Gm-Message-State: AOAM531StSMlQL6DkHwyGVofSthFXA6CVkQfM6acjy+OisMU6XPmNz2H
        g4RNw1FOEw6IhIq18njJn00=
X-Google-Smtp-Source: ABdhPJzmEXdWUuZx5fhEbzrsVr/EGlWP4GM7MVqt0aEc10pbx06WxQ6kZd8yzsP+2ZGbh1oXCMEh8Q==
X-Received: by 2002:a17:90a:4dcc:: with SMTP id r12mr3062330pjl.13.1638319184773;
        Tue, 30 Nov 2021 16:39:44 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me7sm4588312pjb.9.2021.11.30.16.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:39:43 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Warn user if html docs will be missing diagrams
Date:   Wed,  1 Dec 2021 11:39:38 +1100
Message-Id: <20211201003938.4220-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnetfilter_queue is unique among the netfilter libraries in having a
module hierarchy.
If 'dot' is available, Doxygen will make an interactive diagram for a module
with a child or a parent, allowing users to conveniently move up and down the
hierarchy.
Update configure to output a warning if 'dot' is not installed and html was
requested.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/configure.ac b/configure.ac
index 416d58b..f279bcf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -64,6 +64,10 @@ AS_IF([test "x$DOXYGEN" = x], [
 		enable_html_doc=no
 		enable_man_pages=no
 	])
+], [
+	dnl Warn user if html docs will be missing diagrams
+	AS_IF([test "$enable_html_doc" = yes -a -z "$DOT"],
+		AC_MSG_WARN([Dot not found - install graphviz to get interactive diagrams in HTML]))
 ])
 
 dnl Output the makefiles
-- 
2.17.5

