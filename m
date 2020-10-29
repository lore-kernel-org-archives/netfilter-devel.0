Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB97C55179
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCCC206F7
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="cLkms+ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJ2Lwb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgJ2Lwa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:52:30 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF24C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:28 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p5so3432211ejj.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JKPIj+OI8tXboxJo9W9iNBXLskO5TLnc8gjDNSK774=;
        b=cLkms+ubkyFSbAU/usHHriRioXu+wCpVo4bncdyH0ZAtsf0C6W4Opqqp3kJZCu/xSH
         Qw+8RZmRizphZ+OIctMaVNWRrLpLpD1fUEmSP0d0eps03g6G9LXqFtiKZkKARwVcEU4i
         PlTqN+eF7usuRFUJdqna1diTOV+1Hf2y07vNjxKLOYS/4hVfOOBnTegZNG+XngEj4o+y
         cSSuqBnyahoMtZxHFev5X7u6VGNHYmIV2ReIaFvwEPCGYEU91rslbQYwnUvrXALATjEp
         UDprJIy0NNLH1cp2nc/lV8es0mdEu3EXSQwkYZGchrfnxsKJ+cyWW2ZcvZHcX9bWgW/n
         +OeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9JKPIj+OI8tXboxJo9W9iNBXLskO5TLnc8gjDNSK774=;
        b=rMdM0RO/aIP9esOQWBE6rDcgC91+yekSoxTNi1SSw5pkDA/XXkWTbocWYoOq/AADAD
         ET5C5SlJoiEhJd4shKwQkBEnOCbl4hvdmeXQkmvPHD4VenU1qLkw5PiEAHzQft/i+LI6
         W4ajyO+vlku6qaE8iUJH4HjvQaXKbWMlkmggnro5RWfJZLdyX16JGWGEkzcecEmA85/3
         JBt6rGvlaGol+dNx2fEQ8cuRIopvCP4Hma8F/GVpJP2cZmImAI89AXYdb+QkNS44EXC0
         Rl1s9bqtiGvRqdOiDrLz3oq/wRjNCnS4Kr9Y4z6lA1bxi5QBbSpfmxAKudtjjLZ+F6DA
         XrQQ==
X-Gm-Message-State: AOAM532pMRdYA/fOGI3k8G1Tb95rF9eeRrkkhzvdFgc3cOgVXa1UCWei
        W4Uaq7BafBOLDXO6ULpoOxnLcO9CVBamFA==
X-Google-Smtp-Source: ABdhPJwgKXR+gaIZthTaWE7y31RK6lsUVfH0hoSkEqe2XVFkMJefWNDKxq1Uf6zw+erAVunJBq3OEQ==
X-Received: by 2002:a17:906:c1d4:: with SMTP id bw20mr3544216ejb.91.1603972346838;
        Thu, 29 Oct 2020 04:52:26 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id q19sm1391188ejz.90.2020.10.29.04.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:52:26 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 0/2] conntrack: save output format
Date:   Thu, 29 Oct 2020 12:51:54 +0100
Message-Id: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As discussed, here is the updated version of the "save output format"
patches, which include changes & suggestions from Pablo.

Thanks & regards,
Mikhail

Mikhail Sennikovsky (2):
  conntrack: implement save output format
  conntrack.8: man update for opts format support

 conntrack.8                      |   5 +-
 extensions/libct_proto_dccp.c    |  17 ++
 extensions/libct_proto_gre.c     |   9 +
 extensions/libct_proto_icmp.c    |   8 +
 extensions/libct_proto_icmpv6.c  |   8 +
 extensions/libct_proto_sctp.c    |  12 ++
 extensions/libct_proto_tcp.c     |  10 ++
 extensions/libct_proto_udp.c     |   9 +
 extensions/libct_proto_udplite.c |   9 +
 include/conntrack.h              |  30 ++++
 src/conntrack.c                  | 291 ++++++++++++++++++++++++++++++-
 11 files changed, 403 insertions(+), 5 deletions(-)

-- 
2.25.1

