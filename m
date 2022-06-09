Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6B6C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 22:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345703AbiFIWTu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345678AbiFIWTt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 18:19:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A64D614
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:19:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t1-20020a170902e84100b001689cab0be3so2818792plg.11
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VtmBCpNp1KP0Wih0wNtSn6S6eDN4r8qEfTH0S3sfDvI=;
        b=k5UJiPwakkG5FRIZZ5lAwSHv1cl5CV0HckKotKPvFRLB2rm04skCRUAH92Ocj74nI8
         VRgM32h5RM5BUgSugbEFBV15QskHdJF/UARg45aXgMXIqpE44JaqgZSOgpAQZ1jpikDb
         GULMqiClDzX4kfuE9w7o93QGAbqsh6kUT85oC3PEd1vaEzeRnphtmpPAmbhnAhgk6lx0
         LnkSW18ZNlDn2dA0I8HZDUuV5QwUSYnjU7SGR9fWBj1oQGC+opt0AKeg9qvISijvMYMC
         exN/sa9O/SGU7ijyDd9mK0GdtUUcbGfySNVXrOfDrxnggsEQ+nfu/2kYPptx+0sLFFrT
         DcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VtmBCpNp1KP0Wih0wNtSn6S6eDN4r8qEfTH0S3sfDvI=;
        b=pRcrFWUu0/v1ai+8/+/84LyO0IwHn0Icn5ZqPjxdyBlk2X0GBZO6Hw6S3CN1umBYEq
         pQxX7X00AN0JNDoSGOtVbuTCf6hRq2GWIPhmCa5PaYvcuoB0ED9Jnyav0tHwxsgUGGxC
         i52q2GhImqZn8uvpaQ9ZWCXPgf1lbpTVwWIwlG7je6o0vI+S+VuTXfph/7hExgscXd3S
         jrRBP5T6Pqv+Hse+Z26T30U3bJCG7SdwDJHd+IsDHsfuzsWa2AiGH6w0nRxLpSw4QGyX
         GYhY2IoOqQOcFUxuB1ioO5zbWOSQT2sdgeDtPc9brXzOBcHa/s5Qh9p5f14nIYAjC4VA
         1dpg==
X-Gm-Message-State: AOAM5311Wa4lU1T5KiGIsrTv1DSoXI6Dnl0CvsuEWTbwFgbrma9G+jm4
        dywMfU5umiqJDPKg5IwgMnyl3xdy
X-Google-Smtp-Source: ABdhPJyLvkWkgsl5N6fEs4uPVrRWt8N7EGGq7Ji9SRjDngCAZu0NMTQ8venaNAjb270E/IyAc5Cnz/CcgQ==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a63:4722:0:b0:3fb:94a7:9986 with SMTP id
 u34-20020a634722000000b003fb94a79986mr36618043pga.531.1654813173379; Thu, 09
 Jun 2022 15:19:33 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:25 +0000
In-Reply-To: <20220609221702.347522-1-morbo@google.com>
Message-Id: <20220609221702.347522-7-morbo@google.com>
Mime-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 06/12] PNP: use correct format characters
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

drivers/pnp/interface.c:273:22: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
                pnp_printf(buffer, pnp_resource_type_name(res));
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Use a string literal for the format string.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Bill Wendling <isanbard@gmail.com>
---
 drivers/pnp/interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index 44efcdb87e6f..553221a0c89a 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -270,7 +270,7 @@ static ssize_t resources_show(struct device *dmdev,
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
 
-		pnp_printf(buffer, pnp_resource_type_name(res));
+		pnp_printf(buffer, "%s", pnp_resource_type_name(res));
 
 		if (res->flags & IORESOURCE_DISABLED) {
 			pnp_printf(buffer, " disabled\n");
-- 
2.36.1.255.ge46751e96f-goog

