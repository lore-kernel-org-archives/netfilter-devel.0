Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F009C19F2D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 07:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiHKHuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 03:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiHKHtz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 03:49:55 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F458E9BC
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 00:49:54 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z25so24529535lfr.2
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 00:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=XTwyKaGHj3IXogitBMLRWL2Q8J8Oh92B5S3HF1hLg34=;
        b=Da80vlkUIAtcGoUpmVcxdCGANfTWrilpGR5SXODRg0FHJkmgik3iH3Wwk0F6hcDWTn
         Zza7YYAT32P/sNowfiqVXidw8nUsWlK1sdvozPpa+j2falZg3ZDG2e62dQF6LDn2Uy6W
         e4Pvv5Bqo/1EQWMhc8QjAG0nXefeJ08dOz/EVeJ5MfWc5y2roJGYmTMBC7mpQytenPMX
         X8CET8UEY99bddfRYuTIF3x0l7CyayOouo7MNMbvL+Yn3m2hp0tITIULlpOPjX41DGQD
         gRS/AU9LFBmJWecOW5bX8M70jXBBYxHwGPxPTpf4duGm+l8jhj8PC4731lM1iLvedk2S
         kRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=XTwyKaGHj3IXogitBMLRWL2Q8J8Oh92B5S3HF1hLg34=;
        b=QmQ/hsviTFXNaVBu6il6P1oALYstqkRT3tQsZ8uP3GKYjJxupM1VFCzfa03lAVaAUX
         3o6EJfnaw5pqhSqqx5HRuPcd8FdTmLOu9ubYfkiapiRBeD7W4GEmjvCSX9Q2jR8tvB0e
         W+ULMR+zA6MiiPYFGKbp6Cxoz1eeJqAnOPfKEPZa2quSIYUh6ETiMcJ8SxWTmpvhM7V+
         GoazPxf26BWJXRFtVKT8O+0HUKNulfSmMHx0NQSzC4C2pP+t7TTXqDuNJk0dV3QxW76/
         u67uODV0WCUUaTf7xb6L/VVxl+fsap/c9CBzwIeS3RUSQLrXlUztN6WRDAIvnpgNcxVY
         XjgQ==
X-Gm-Message-State: ACgBeo2tN2n4ZRphbP3UjIL8DIMoADsd+rQbs+ZrxVVgEzd63/Dg12cM
        +XXZR3h3DasoTy52TkADJJpGzgeCiZ0Kp/v/YUDiHZMMULJTtBO/Tak=
X-Google-Smtp-Source: AA6agR5Q4rt3U6WEpi0rCBO0XxszsJs4p+E8yxgbrA2WOv8DL4/I+ayS7kLrWEt7SPDO9nGwDBUZNJWQQSSoDR1jviM=
X-Received: by 2002:a05:6512:4010:b0:48a:f3df:e9af with SMTP id
 br16-20020a056512401000b0048af3dfe9afmr11133482lfb.131.1660204192641; Thu, 11
 Aug 2022 00:49:52 -0700 (PDT)
MIME-Version: 1.0
From:   Turritopsis Dohrnii Teo En Ming <tdtemccna@gmail.com>
Date:   Thu, 11 Aug 2022 15:49:41 +0800
Message-ID: <CACsrZYbEL+rdWL89cMD4LZT=MQOOoruTOCYYjHM+yeaXzv-YLw@mail.gmail.com>
Subject: Upgrading iptables firewall on Red Hat Enterprise Linux 9.0
To:     netfilter-devel@vger.kernel.org
Cc:     ceo@teo-en-ming-corp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Subject: Upgrading iptables firewall on Red Hat Enterprise Linux 9.0

Good day from Singapore,

The following RPM packages are installed on my Red Hat Enterprise
Linux 9.0 virtual machine.

iptables-libs-1.8.7-28.el9.x86_64
iptables-nft-1.8.7-28.el9.x86_64

Is it possible to upgrade iptables firewall to the latest version 1.8.8?

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
11 Aug 2022 Thursday
Blogs:
https://tdtemcerts.blogspot.com
https://tdtemcerts.wordpress.com
