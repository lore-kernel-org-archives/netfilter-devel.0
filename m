Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242D2C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 04:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13C8610A5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 04:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhHMEpK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Aug 2021 00:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhHMEpJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Aug 2021 00:45:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB16AC061756
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 21:44:43 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so19000731pjs.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 21:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xuKncfOPSBTpSoTaGwjN5Vl+vzNWpXdvaji1fVUtT34=;
        b=iP+PvvwQ8bTHqviaKWgS4kQEUst49T/moX4HGm2zOmreZ2dA3KdYxUoxQskDXZhxFB
         kFcmp+f0ljtwA0TN2AiQc7l3wcMfPau0QS0wt5XJcvTd0FQHrqQSScrmxOMNYJVFErH9
         XAVtrO+FCYF5JXjLHvLL2XUYTvId+fBoN5NdAucEHEXxEr1AUjXR9h/OHPEMpgs2JESy
         mUwXeiii/4TDOb1cWo5b8XcLDf6qy7xBUVOj2lEzWh2G9wKRS6UtPUj9CsCpzQRPHbJD
         lstHMfyyXzCDZzyGo327BgIbjcKbgolYHAUXy5JDS4zzspQiuRbIMnEChGNaYlCnu8Cb
         dgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=xuKncfOPSBTpSoTaGwjN5Vl+vzNWpXdvaji1fVUtT34=;
        b=mA+K90kZf8gjjyqx0LpfGIsPOlkC0rTSmfCyyGrUhgbGyTXPwkqMzX9dQ1H1Je+cmu
         Kc1I6q6dPX6I9pG09cxr+ywmRrI32PbHyr8HIm7EbvH2R3kmdLkM8fa1g0fZQwSyELHe
         F/kRUjWgMgaaTrMiPqDfb5i9wfCTgOyklfTOfbb/sBMH1vhMfRWRi5R41X4YCz8Dba5K
         KKvkYLjfMkqP7VsuXeNmUHUKkLu+txPH7RPsheh4ZnJUxTYwdkg586ws6ZKxROu1FTFt
         L9lQvBmNqffxp2TxRw9dBfLw673sKQJ6J1IgddRpnL5ujqdFKdTwpqCUov/zr2RRlrSr
         CO2A==
X-Gm-Message-State: AOAM530Uts7sGxMZx/zDXo6x7mLoJdNPbD3+pSvQOeVG6al0W8sK+bYJ
        cbvlB2dhy6kpHRfuq3vIkicOFbBVXx0nEg==
X-Google-Smtp-Source: ABdhPJwuLdpCuTNU9ysjZ3Jz8LtKn+Sa1ZOZfPjyCOBh+x4hkMw0iOju3hlQ8lf/QIdMyDVIP2xgmw==
X-Received: by 2002:a63:a54f:: with SMTP id r15mr605269pgu.212.1628829883370;
        Thu, 12 Aug 2021 21:44:43 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s23sm427116pfg.208.2021.08.12.21.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 21:44:42 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 0/1] src: doc: Insert SYNOPSIS sections for man pages
Date:   Fri, 13 Aug 2021 14:44:35 +1000
Message-Id: <20210813044436.16066-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here's a simple way to test this patch and the associated
"Fix NAME entry in man pages" patch.

1. Apply the 2 above-mentioned patches

2. Build the result.

3. Ensure environment variable MANPATH starts with the 'man' directory you just
   built.

4. Issue the following:

man nfq_create_queue nfq_get_gid pktb_alloc nfq_tcp_get_hdr nfq_udp_get_hdr\
nfq_nlmsg_verdict_put nfq_bind_pf nfq_ip_get_hdr nfq_ip6_get_hdr\
pktb_mac_header nfq_nlmsg_cfg_put_cmd pktb_pull nfq_udp_compute_checksum_ipv4\
nfq_tcp_compute_checksum_ipv4 nfq_snprintf_xml nfq_nlmsg_parse\
nfq_icmp_get_hdr nfq_ip_set_checksum

5. 'q' each man page to see the next (maybe ':n' on some systems).
   Verify for correct synopsis and general appearance.
   (If the page is shorter than screen lines, 'g' should put it at top).

Duncan Roe (1):
  src: doc: Insert SYNOPSIS sections for man pages

 src/extra/icmp.c         |  9 +++++++++
 src/extra/ipv4.c         | 20 +++++++++++++++++++-
 src/extra/ipv6.c         | 11 +++++++++++
 src/extra/pktbuff.c      | 37 +++++++++++++++++++++++++++++++------
 src/extra/tcp.c          | 20 ++++++++++++++++++++
 src/extra/udp.c          | 20 ++++++++++++++++++++
 src/libnetfilter_queue.c | 40 ++++++++++++++++++++++++++++++++++++++--
 src/nlmsg.c              | 28 ++++++++++++++++++++++++++++
 8 files changed, 176 insertions(+), 9 deletions(-)

-- 
2.17.5

