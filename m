Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B27C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 22:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiFUW5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiFUW5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 18:57:00 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CD82E6BD
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u12so30482914eja.8
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aALlbnDntCx/aSqNdMoHI5xHLUojK1Pkmom0HVwgdXo=;
        b=Pfs9w3eR4UUt/Ng5AhtSYMU8b5R00or5NJ0B4W3oc5VgtPLIl8nBq3g7WQNYGfUjfU
         DrFH03vmfZ9q/f+Pxx8pNjV+NluFObttIx6ZBkpHhnOnU3HRWxe8NHMLIL030K3Q8T76
         5yaY6QyB0bEkiu4EXD4w1GAC3cqZaPdRnDSuZFkd3DUVz4X0nCbgSsIt5KpvBU289Ap6
         2I0MVb6AM+eDsdUMD/0M3ZJpGZt6S/BhGtN/fJ7oKE+FQkqXGt0ZSsN8M/ksft7v2bm4
         2nsitx8+XEQwX6vLh95++3KeKvfHC7unEydAgazn8dPWY9o4w4ydeAE41WHyEMw5RiSO
         DZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aALlbnDntCx/aSqNdMoHI5xHLUojK1Pkmom0HVwgdXo=;
        b=23aRFb7QjaqhR94IDuOz1mxfiFqHuW80GfIN7QQyGpOmeg5fg/voC687svK0uvoxTX
         J830OBUVzRyYPB68elqBeWWE8ZKA794EMbzG1pz81BRlkSgup7uF9mAEky2chWOHHDHy
         cquOD6/2oeMuP+mNlI5cW9/6zvjgopt9+3nwYiqlSpnCYK9kwg5pLYmj1QFSRkcNpkVZ
         NeGVjsdS0lyNoSQhh9hFp6fp749TBJxXrtXgIyG7JVG//AXgir/uD0U1yW/mwNqGFaVH
         yUx8CGF38qI4ecMsWAyqpKG/d6qGkmIIarwnzklpT9LKla/Tkx1cGmRTHO745lVcqHmt
         3Z4Q==
X-Gm-Message-State: AJIora/FafyhWAqoAls6DpyftXMpvC2RSu5qYzHcWpOUk+wAAvMnQHeW
        oXiGQrzAwpI0RkLSPBKubZtWVz2C32EtpQ==
X-Google-Smtp-Source: AGRyM1siq00oaMXxVYlbgmEwYG92B/m3Ih5b8MmKj/g7sYL7RAJ6wGLo2QxXg8MWEgiq+KTuO6qDWA==
X-Received: by 2002:a17:907:7f0f:b0:722:d5b2:8736 with SMTP id qf15-20020a1709077f0f00b00722d5b28736mr342089ejc.279.1655852214071;
        Tue, 21 Jun 2022 15:56:54 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id z12-20020a50e68c000000b004358c3bfb4csm4540118edm.31.2022.06.21.15.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:56:53 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/3] conntrack: -A command implementation
Date:   Wed, 22 Jun 2022 00:55:44 +0200
Message-Id: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As discussed, here is the implementation for the -A command.

The -A command works exactly the same way as -I except that it
does not fail if the ct entry already exists.
This command is useful for the batched ct loads to not abort if
some entries being applied exist.
    
The ct entry dump in the "save" format is now switched to use the
-A command as well for the generated output.

Regards,
Mikhail

Mikhail Sennikovsky (3):
  conntrack: introduce new -A command
  conntrack.8: man update for -A command support
  tests/conntrack: -A command support

 conntrack.8                       | 11 ++++++--
 src/conntrack.c                   | 35 ++++++++++++++++++-----
 tests/conntrack/testsuite/08stdin | 47 ++++++++++++++++++++++++++++++-
 tests/conntrack/testsuite/10add   | 42 +++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 11 deletions(-)
 create mode 100644 tests/conntrack/testsuite/10add

-- 
2.25.1

