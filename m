Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9B4CCA47E
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 22:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345519AbiFIWRU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiFIWRS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 18:17:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C6948E54
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:17:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m11-20020a25710b000000b0065d4a4abca1so21388574ybc.18
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ig5mQ0gyC0oce1d/Zy8bEsqqFhtDY79w4cUoB0YUJhk=;
        b=V05U+x4LNh+To0zL8TXuNjeoTipGUWzS4C+mJRGY7QgduElSX56iUMHvUvLMhzjI09
         E+x7NCxoYFqVyFXI1TlmbTkoG0K6EXcMKlrYySH1QuvGlP37jlNn3/LNPCdiYeEd0GEX
         LIv1t4Su+H6fvGFvlkkmP2vDMIKlG+WobBu9nm/V5Y5/3H69sLKj+5cEln+2znKR6SCR
         fC2/3m/sX6SBfZ7eQ1UCfi6CIHJU4yas6UeLgZ+2cIhzSthWxwnpXo5pPTasAbA9B0Xs
         rfxKIB3w7yzCPfuUTDB83U0KP/M39tuXj5LkDncm21ZIAnPkSh3VMh/A84ECTFd7kj87
         IbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ig5mQ0gyC0oce1d/Zy8bEsqqFhtDY79w4cUoB0YUJhk=;
        b=HWjDl0M/aApq+q+CaOLfNyp+/ekAMa9Nwa1cP1WCrJFjzPaVbT9wu2LLJOseLyk6cR
         tXj4KyBUmx9mA+dTDFazTbdz2SrKf7msMmlxqEcQexDcCfqd3uTy7S/v5+KqBmAI4pVn
         tE0erGLyI0UgIepx0sPycHzUGKrkWF3loWUU8cwOeoeLtdYbquoIIPioh/2eiSNB8wZK
         dT7AVueUztR7HzGD4JqKtLHcucOvegdrXIhUbWZzcLRRwsFO7w4velj4/zCjfaT0v9vd
         hDgTks+xs0kSrR+Aj1xbYnEBYqVBk2fsQhj/Z/PPOLeMLAX/QAF3VIs5NDp1WjPdYdJX
         e69A==
X-Gm-Message-State: AOAM532oaKORYEggucLmmmwhEmY4f65ESzVCshLoU6aL5CRbkV2e/AVP
        9+SzzA7mX7/RNdoR7a+WtuynSHcS
X-Google-Smtp-Source: ABdhPJzwx5X0ZE/nM+u+DgO5va7z203Jwou06sjKdU0c0pt2CnSBxfb1v768IuoKgsISspKmOdai1Wxx4w==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a25:2985:0:b0:663:ec6a:4ff2 with SMTP id
 p127-20020a252985000000b00663ec6a4ff2mr14049602ybp.166.1654813036265; Thu, 09
 Jun 2022 15:17:16 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:19 +0000
Message-Id: <20220609221702.347522-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 00/12] Clang -Wformat warning fixes
From:   Bill Wendling <morbo@google.com>
To:     isanbard@gmail.com
Cc:     Bill Wendling <morbo@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
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

This patch set fixes some clang warnings when -Wformat is enabled.

Bill Wendling (12):
  x86/mce: use correct format characters
  x86/CPU/AMD: use correct format characters
  x86/e820: use correct format characters
  blk-cgroup: use correct format characters
  fs: quota: use correct format characters
  PNP: use correct format characters
  driver/char: use correct format characters
  cdrom: use correct format characters
  ALSA: seq: use correct format characters
  ALSA: seq: use correct format characters
  ALSA: control: use correct format characters
  netfilter: conntrack: use correct format characters

 arch/x86/kernel/cpu/mce/amd.c       | 9 +++++----
 arch/x86/kernel/cpu/mce/core.c      | 2 +-
 arch/x86/kernel/e820.c              | 4 ++--
 drivers/cdrom/cdrom.c               | 2 +-
 drivers/char/mem.c                  | 2 +-
 drivers/pnp/interface.c             | 2 +-
 fs/quota/dquot.c                    | 2 +-
 mm/backing-dev.c                    | 2 +-
 net/netfilter/nf_conntrack_helper.c | 2 +-
 scripts/Makefile.extrawarn          | 4 ++--
 sound/core/control.c                | 2 +-
 sound/core/seq/seq_clientmgr.c      | 2 +-
 sound/core/sound.c                  | 2 +-
 13 files changed, 19 insertions(+), 18 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

