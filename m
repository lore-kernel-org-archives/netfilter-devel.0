Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29406C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB6060231
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhHLB4l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 21:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhHLB4k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 21:56:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDCDC061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 18:56:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so5162456plg.9
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 18:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABYrDPt5V765rvQTQCU6yJGj8mfNU9WLu+qfo3AaGno=;
        b=SpuPKzN8JPALqCquMeVi1+tAxWDWjg8H+T1IoF9qL/Gmk16MN67mcTLflwGAxLGs6G
         PDg6QpkIpeI9z0x/6AwPqy29HrJP3M7lBe8MKnAx8uqEPKthLDwSohRQt4FJzQs3Qh6J
         zYEVex3EWWjjbxWueTtIXrtCzSzS7NxlVd1qqeqUdskv5Dtb1sll4ItymBLc4w4T4l3Q
         WEjdi28gnfnAuN3WKzgedqQ7AwDApipEm+LyBrJQgiHj9DxvehpcbzlMvXQa0eDmZLbW
         BA1LtuEClXbkjv7Ab5QnFeYVdxHUACYfypc33eLWhoGPQiCPRzcs/1PabZXDqxf2oDCH
         315Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ABYrDPt5V765rvQTQCU6yJGj8mfNU9WLu+qfo3AaGno=;
        b=IA+Wny5PK+3SnOMlYSInlpVK6+v0E/4nmBp2zA/Bimsd1El4BrpZFUTUydWyyREHKa
         VeXST3FcV24qYicbB9ykE8uPq/Dlj+tIUqz9+5JxuSLtjbVxme4lf9ZVv/V77mYJC5ys
         /ecUg5NcaGBavNwUe3rAMAlJsiRVdGYLegpNj/LmvjKsW6q2ErlH34369W02ETMEaX1a
         g/DtCRQ0Umhjaosp4e3MW2M3miTmo4304G2OMlvoRMyVmkYCo3Xxh2XkOib+RuOvULjH
         P+vzVRdZBZzeT52iZi4vDKRbgbD96phzpoUjIc8ymMwNPow5eUizb0mvHzPUAqyPw8t9
         GPKQ==
X-Gm-Message-State: AOAM530i6TkS+MMjl+Lm64gXvWLLPxDag/39ZwPLLFBIqVPGZh04sW+b
        kJw1x23LC4wPcBGUKr7016oaJ7zEGPZq1w==
X-Google-Smtp-Source: ABdhPJzlg5Cuu7/91J12BJ+hnyGVpvhRstvgBAKfRqrnXeTs0a2PpZR3Ce5pKMkxovcUf8/3TUzHGg==
X-Received: by 2002:a17:90a:f3d2:: with SMTP id ha18mr13602514pjb.232.1628733375829;
        Wed, 11 Aug 2021 18:56:15 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id m11sm8225523pjn.2.2021.08.11.18.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 18:56:15 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 0/1] Insert SYNOPSIS sections for man pages
Date:   Thu, 12 Aug 2021 11:56:08 +1000
Message-Id: <20210812015609.14728-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a rebase to 50b3846c (master) of
"Insert SYNOPSIS sections for man pages".

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
 src/extra/ipv6.c         | 10 ++++++++++
 src/extra/pktbuff.c      | 37 +++++++++++++++++++++++++++++++------
 src/extra/tcp.c          | 20 ++++++++++++++++++++
 src/extra/udp.c          | 20 ++++++++++++++++++++
 src/libnetfilter_queue.c | 37 +++++++++++++++++++++++++++++++++++--
 src/nlmsg.c              | 27 +++++++++++++++++++++++++++
 8 files changed, 171 insertions(+), 9 deletions(-)

-- 
2.17.5

