Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED96CCA473
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 22:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345651AbiFIWTY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345698AbiFIWTT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 18:19:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B3B47ACA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:19:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b15-20020a170902d50f00b00167501814edso9726535plg.8
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fWdTUxWRVXkKLWYheGOI11e0mL2XAHFKbZxg8ksMoZM=;
        b=ezNDouTkewW/awvW/cRvKC6jHhcMBl4eQkJi6sdP+X2J6iJMkd00jA2jaRJhpFY7aw
         yxivdcEq++4iV1GgB2ziv1ayV3oP8FWg/GB0Zo4bN9LSRrIbKMWW4pYYedFNqaZbtBdq
         LI7orAiKEXNDUMTMRTz+eYmtPr0ihFSVRZhCMEgns7LQjXXffU9ysRs8Jm7/xp/mkHV8
         hqJ/WTn4IigfYhYdyyonY3s//N3eKAKkW8RZYgrVC9YsY682gIJn1c0bZa76vTplgKaA
         3OGnJiqbOGhiGk4PrcLnGinCbRAB3xGsfKwPwyZscTB2mgetoP8/LmB/5HB6hMrHCgU0
         s7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fWdTUxWRVXkKLWYheGOI11e0mL2XAHFKbZxg8ksMoZM=;
        b=KQ4El7obuWveyR6lTc1NP4lUeRdWcSYlla9WmAPF9XalwVy/PQBnkRzPdwfYToox2h
         28fV7a/UpiFQymjiVAaNSfZ7ol0kyItwn99UYUCtlliCTA1kPah72Rbn6B7prrTYmyEQ
         CnYJMBOd0rxtOEY4xQzYpWCSc2kCsVMC0HstZwocFBQwJ9pezj+D7v0t5NxGDP9dWamS
         Oqp5BSzBvshhe3ibmnbpmh2PjNCzfUAsHcwwtjS7DL4OhoD4XCPHDq/sifDjcfH7s0cP
         7N4XtsacyGKxkV8ub86QSQw3rtI3CnBKN0Jed7co29v3cnQFT5v9bgQy7+Ds4hM2Ao7F
         SH4A==
X-Gm-Message-State: AOAM530v5xxBGF7FgIAvA5+INY/YoB6byfbThIoJYpH8dXw4nWUiWTBv
        LDEEpDcir3wqQ9KEOclPJxh1Jlca
X-Google-Smtp-Source: ABdhPJymRh8XdI6qUr+0U3jn9BPA1WS3MroiwqAq54XxkobNI9HSYvmGC6qhWN+ZtdS8zin/gyNAdfGHUw==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a63:c5:0:b0:3fe:26a0:7abe with SMTP id
 188-20020a6300c5000000b003fe26a07abemr10973746pga.152.1654813150612; Thu, 09
 Jun 2022 15:19:10 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:24 +0000
In-Reply-To: <20220609221702.347522-1-morbo@google.com>
Message-Id: <20220609221702.347522-6-morbo@google.com>
Mime-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 05/12] fs: quota: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     isanbard@gmail.com
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Bill Wendling <isanbard@gmail.com>

When compiling with -Wformat, clang emits the following warnings:

fs/quota/dquot.c:206:22: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
                    request_module(module_names[qm].qm_mod_name))
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use a string literal for the format string.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Bill Wendling <isanbard@gmail.com>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a74aef99bd3d..3b613de3b371 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -203,7 +203,7 @@ static struct quota_format_type *find_quota_format(int id)
 			     module_names[qm].qm_fmt_id != id; qm++)
 			;
 		if (!module_names[qm].qm_fmt_id ||
-		    request_module(module_names[qm].qm_mod_name))
+		    request_module("%s", module_names[qm].qm_mod_name))
 			return NULL;
 
 		spin_lock(&dq_list_lock);
-- 
2.36.1.255.ge46751e96f-goog

