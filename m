Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DF3CCA47E
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 22:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345628AbiFIWS3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345615AbiFIWS2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 18:18:28 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC0C427DD
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:18:26 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x11-20020aa79acb000000b0051b9d3136fdso12985048pfp.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zQ6igRU/lPsPPjITd4pdT0XeOfhGOx4hu6xL7AAJoM8=;
        b=QJYSL92EGHv0Glqefsz+fZAyuHXsVDJ+MxqtY38p/rJWyzN9tqq38im0/nAHSSrAcw
         XMQ6nAGoVVakkYRIOxtqwHJW03YmZH40gkW7E/YkdAEWc9hWN2V7ngXOGdkLxNXXFPVz
         MM6SoDd9zGDwN7h4y2Zv5sUmYXsKm79QEart8XywqgYgGMlR5uKSmr2M8zPPYELNG0fC
         sjbVW5cOWu2CabVPyhNOvTWLIe4OkL9eosbWQbgqXLmWmjLl4VHTPCfxGjF9R4eBYA8S
         SWfDBEXFQ0GXfeXiQjFQ4xktd6Mieq2x7asfEjehSXBFdpIoHP2WaOku4Aej/pIaybf5
         FCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zQ6igRU/lPsPPjITd4pdT0XeOfhGOx4hu6xL7AAJoM8=;
        b=Xe/a8zV46h3Jb4qy5odPGyE/NjZSLyCGfRVlteOROCA/XuStQaBrd3hngVVtPHDSNG
         rX4nUsBsn8+Y8Ps5kOTch9HotEbVUT0cgyxkbHkBZLEau5RxOiFZjMUjLH1zMsriFSCm
         KTB3YDrlpDvUkX9DCxjV5mKd+yeEmDyWDcRfV9xqS2Fy4KkWVoagjvw2T114RepMkkI0
         +RHxMuLBeg4nJVHMyGrT4zwLnWZ6HKitSMXdHtcgkdn/nFnAdtE/Uns6WD+XSt5aLcU/
         WyhOg+eOb1HFCODtwoDJiQbXyBYdpJoqyQasBEAmtTYUtIfmP1KogFakZUstUMLQJbPd
         UK5w==
X-Gm-Message-State: AOAM533CqL6ggkZIkXvbmLUDgzEx42u9iq3t1n5oOq2Bl8Oe1hyW40Wo
        B8n18kpPax5xmBra4POiEHQq0rnx
X-Google-Smtp-Source: ABdhPJwaaQIFrsaGRD2eHE0bL/iy5r4Z+mF9XLusw0L85/0I2ggYu7uuJziQ3x377wlgzuNlbfNxKB4Iyw==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr114285pje.0.1654813104885; Thu, 09 Jun
 2022 15:18:24 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:22 +0000
In-Reply-To: <20220609221702.347522-1-morbo@google.com>
Message-Id: <20220609221702.347522-4-morbo@google.com>
Mime-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 03/12] x86/e820: use correct format characters
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

arch/x86/kernel/e820.c:877:15: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
        early_printk(msg);
                     ^~~
arch/x86/kernel/e820.c:878:8: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
        panic(msg);
              ^~~

Use a string literal for the format string.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Bill Wendling <isanbard@gmail.com>
---
 arch/x86/kernel/e820.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index f267205f2d5a..ca4634a0bdb5 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -874,8 +874,8 @@ unsigned long __init e820__end_of_low_ram_pfn(void)
 
 static void __init early_panic(char *msg)
 {
-	early_printk(msg);
-	panic(msg);
+	early_printk("%s", msg);
+	panic("%s", msg);
 }
 
 static int userdef __initdata;
-- 
2.36.1.255.ge46751e96f-goog

