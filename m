Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AECC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 14:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbiCVO14 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbiCVO1I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 10:27:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14BD24BF0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2022 07:25:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c62so2371192edf.5
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2022 07:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgwXNK50+akv3a8fFATpQWX1R9jgdLrmZ/94oCAi9kA=;
        b=Q0wTJ0AMu1liHiDvYWx1QMGsAyAOywUw0h4l4pd8m86YoM9ojmmrSP3YT8gimoQFqL
         z0TDLZBoww9W2k5cmA6U5bP+3MpSfrTXNcPAGEV3XCzODlHVOcjV3is1RuCnpH/Y++za
         UDaj2CFW9XAeDMGDn3jDWlQ+2xgc3rubwfTJWUnHxwVHraDPDSAV22AxCM1SsVfcwBA5
         SGeZaOlWvx+PHm43p55rvNkVRHqW4N3bbxgiI++bUYMyLJ19FfS98EZhZ+P0uNfzV1LH
         mYbDubb8WFzHXrysJK0a/IYY3qqIGK5iGXBYo1lGkRpjDGBBfa+xyHPuU6v+ANApep9i
         SmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgwXNK50+akv3a8fFATpQWX1R9jgdLrmZ/94oCAi9kA=;
        b=oACgRIl26+7nL6pI59lcbyuo/j/uQXyb837N99AsflRFdeYOjwjBUJr+qvxu21kM01
         1gchz+RNc+53+tWJ3shZYDu9Bq4PoSEnMsoE5z7X59LWAaJQkB2+SEAmsBRvPnuUalqw
         9k6SXQwFWjP5OatBsdlMcOrZe51r3ou+GAWD3mLc3LTKPvagPboqg2D5H7K1UQOAQCh3
         up5HTU2LsApmpDRCXxOfN940JHzKWyxTd3trCuaLLwTeerFdGoSOUIw2mWutLV7JFLkW
         1spQXFUl45EL9XaAiS7U1styADV7MsxccS7Kh01k9sFvZeolFgcFLhxmMWs6qJNebVsF
         KVyA==
X-Gm-Message-State: AOAM532DC3qF3dpVuTyOAB738mI/IauzqnwEnRCy13MHvS+pGgvAo2Rq
        Lir7Sl74bzouPc88stNugir0SKtPgXCCvg==
X-Google-Smtp-Source: ABdhPJyGStmwirexgQMIoudGG31da43HQed5JzbC2KDpbVGCO4C0dgvzvNqYS3yYEceaQelEy+4TSA==
X-Received: by 2002:a05:6402:2553:b0:418:ff6a:ca66 with SMTP id l19-20020a056402255300b00418ff6aca66mr26049478edb.273.1647959138764;
        Tue, 22 Mar 2022 07:25:38 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd42e.dynamic.kabel-deutschland.de. [95.91.212.46])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7c38c000000b0041939d9ccd0sm3351465edq.81.2022.03.22.07.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:25:37 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/1] Reusing mnl socket for bulk ct loads
Date:   Tue, 22 Mar 2022 15:25:23 +0100
Message-Id: <20220322142524.35109-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As we discussed, as a follow-up to the recent adjustments
of the conntrack code to use libmnl, I'm sending the updated patch
for using the same mnl socket for all operation in bulk ct loads
to increase performance of such loads.

Any feedback/suggestions are welcome as always.

Regards,
Mikhail


Mikhail Sennikovsky (1):
  conntrack: use same mnl socket for bulk operations

 src/conntrack.c | 70 +++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

-- 
2.25.1

