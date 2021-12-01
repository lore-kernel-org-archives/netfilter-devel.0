Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B647C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351936AbhLARgr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351919AbhLARgZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:25 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F35C061748
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:04 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d9so33138586wrw.4
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OLIUQGr/uV+Q63AqXTSSth4T2CYBaqf451RN1Zyb4Q=;
        b=UkX5S1jZFJf+T1RWkkIz/6hNplXlgCZN2lr2rO6fzqQC34I6l/Zo2XP9CqMyFSh/pr
         aGmpfYPsgjIVH4L3SKL/IkPVRrjNSQpGgu8RPw95N0rRsVpkD/345m19UJe3q4mmABpT
         0gtqgJECFiNHI0Nyw8er2PXTAMLKdSA+uo09WkPy2nDszQ8R076rV7ah5q7HDp/bc+ng
         tnHZ06hVlKed4UHFwRLyrrInZKdz79JpyAqSY0OfPcfzdrjnYCWfNeL12NZkh4qd55IQ
         b66iDUR/vUsK8+wofEqjy4C/Ib+mo6sleNQVpIq6XILOvjG9jBUzoxXKuSOwMlXqp7q1
         XMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OLIUQGr/uV+Q63AqXTSSth4T2CYBaqf451RN1Zyb4Q=;
        b=PDoUv6MR3pJ4wgJ2Eok8+88OuRayIArMxbdy6BWk+fFL+vUvjX9xLX71zj9MEnO8NC
         5BK9f27JZHFtxodeZL5+kfVUblwaaOvI9X+hh19jU0lfiJc9GUqElRjHLpsueqww63SQ
         R4Q6CGNMPHqI/WAo7Fz5byPPAzh5U750ti8+Ebyi0E77KdbDK3yYBDjFBG3l1/LKMmGb
         PR5o4S5Dv8NYQ6HONFC9CEU5YHNmVxYrvknby+9qLZMWfhKSWuQ2NdXf4Zlk6Xuykhbr
         D/onywEDYO6W9vtjUiOky9eWp5onccQgFCxuhQKJGNU/n8I8FmJRUf+uwOrbMzbs9mtA
         7GMA==
X-Gm-Message-State: AOAM531NbrbYrZs0x967PmQa3wwvdMl7bUWmOJpYn3/yYCdvkTdWuylF
        NihWTZrGz6Ox5hde49JVhFXf0faT9bYl/A==
X-Google-Smtp-Source: ABdhPJxdunRAsYNxl+y78kbWcf7bq2wnweymbKgGubzHSOuUjQ3L5NtcLQQJoUu7OBcyCYxJrDL+aw==
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr8417982wrm.60.1638379981574;
        Wed, 01 Dec 2021 09:33:01 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:00 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/6] conntrack: use libmnl for various operations
Date:   Wed,  1 Dec 2021 18:32:47 +0100
Message-Id: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo and all,

Here is a set of patches to switch to libmnl a set of commands
that can be used in the load-file operation.

As discussed, once we can get this set of patches applied,
I'm going to adjust my previous patch of using the same netlink
handle for all operations in the load-file batch,
and as a further step I would also adopt all the remaining commands
to using libmnl.

As usual, any feedback is very welcome!)

Thanks & Regards,
Mikhail

Mikhail Sennikovsky (6):
  conntrack: generic nfct_mnl_call function
  conntrack: use libmnl for conntrack entry creation
  conntrack: pass sock to nfct_mnl_xxx functions
  conntrack: use libmnl for updating conntrack table
  conntrack: use libmnl for ct entries deletion
  conntrack: use libmnl for flushing conntrack table

 src/conntrack.c | 529 +++++++++++++++++++++++++++++-------------------
 1 file changed, 316 insertions(+), 213 deletions(-)

-- 
2.25.1

