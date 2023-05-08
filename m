Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA95C7EE2A
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 03:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjEHDOu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 May 2023 23:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjEHDOt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2023 23:14:49 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDF07EE2
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 20:14:47 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac79d4858dso44536491fa.2
        for <netfilter-devel@vger.kernel.org>; Sun, 07 May 2023 20:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683515686; x=1686107686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JdyRDz4i1U23ArVkKcC+zMLk+f8gWa9ekYXLc7EvaIE=;
        b=hbRHWnZxXv5Expp+cpVs0HrKgRvk47S2plphFpeMpz1MagnrFgViD2J0kMUE4FQ9E/
         x2Rv1ZDpa1LOHQ9tcbyHfu+k/hIzGXfPLHB2wkkr5S+gM7l1KD8nQ6nhsKpBTCeF4ZwD
         YnpZQL63/vIofKIWuC0p5NWN0nrbtgVKiJZ4Z1NXL5YkoVbFRZNdzirti0yLURWISaNR
         nFokZZ3XEAuJyjyZ9hbwjn6uC+uCb8ssLFlUYDNuzskJ2j/zlxyrD6SOkWCd0tWvjXmR
         qpXcCXi4EbI1V3hFF6lbvz5btx2hi7VgM5v9MGilsE0l1/eyZkaVsX8VbRP7LvIdTjuX
         By4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683515686; x=1686107686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JdyRDz4i1U23ArVkKcC+zMLk+f8gWa9ekYXLc7EvaIE=;
        b=lCLD9x0S5m5jamPouPdss/e1gwmdzwT/cESeB/gi77vXTl2yxph5q88IZ+ABCPCl7e
         yXIWt/xg1+unL4jQgHv8wwwopXpLDZpxXt+54UztFGJc5FZmNJHOJOhBCWalCoYriSXh
         2n5Z392XOEezUfc+Wg3Q1XCqOBmkZsQX2SkOkwIvbHmzo4fbDINjF5RDtDyVWMjOVzp+
         +RQCOM+9isRf2M5WlxbNJUxF3j2KSLuicWW3ln1CTDH+PbX3DbSlcMKJxHfkTFGKMX3A
         v0SPKKzzrVBDVqv63oazGj7ciJ12N4JgOkbj1STKl1xCwchjrhUDWMG+2fTHP5BlrDKL
         rgjw==
X-Gm-Message-State: AC+VfDwI6hpzdMKIFc1qGf4P5SvknXLRsEmSoafs9OEdX1h0PsZTPMNH
        ki4NDBlnaRJ6HknNa1O4AqN5ydzThw==
X-Google-Smtp-Source: ACHHUZ6uJiyb/N/75PFgnU4IEwxPzo3RgS9gRgApQlsLBnNLL2u8rnWAbl69jvorQndxX9UWsJ33kQ==
X-Received: by 2002:a2e:8758:0:b0:2ad:9154:c979 with SMTP id q24-20020a2e8758000000b002ad9154c979mr510685ljj.43.1683515685901;
        Sun, 07 May 2023 20:14:45 -0700 (PDT)
Received: from localhost.localdomain (77-254-67-144.adsl.inetia.pl. [77.254.67.144])
        by smtp.gmail.com with ESMTPSA id j14-20020a2eb70e000000b002a8a77f4d03sm1018850ljo.59.2023.05.07.20.14.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 May 2023 20:14:45 -0700 (PDT)
From:   Patryk Sondej <patryk.sondej@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     eric_sage@apple.com
Subject: [PATCH 0/2] netfilter: nfnetlink_log & nfnetlink_queue: enable cgroup id socket info
Date:   Mon,  8 May 2023 05:14:23 +0200
Message-Id: <20230508031424.55383-1-patryk.sondej@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

I'd like to propose this patchset that adds support for retrieving cgroupv2 ID.
This functionality is useful for processing per-cgroup packets in userspace using nfnetlink_log,
or writing per-cgroup rules using nfnetlink_queue.

This is my first contribution to the kernel, so I would greatly appreciate any feedback or suggestions for improvement.

Please find the two patches attached.

Thanks for your consideration.

Best regards,
Patryk

[PATCH 1/2] netfilter: nfnetlink_log: enable cgroup id socket info
[PATCH 2/2] netfilter: nfnetlink_queue: enable cgroup id socket info

