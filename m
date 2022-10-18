Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F419C43217
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Oct 2022 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJRQpz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Oct 2022 12:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJRQpx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2022 12:45:53 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A435BE53C
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2022 09:45:50 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-12c8312131fso17497219fac.4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2022 09:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NMNhWn4/O57Tf5yTKD+cDvNEGJasCt6XyYAuj5ely1A=;
        b=eveKQBjLlZkxQb65EIwbnitWJ/eiC095yijunSH9hQsaq0+sVPAWTI6DiIcPDSBG3g
         pXko4ETWtWGRRQ45XY6soom2j8ElNf7krUJMYy7eEVSDVbWPl+Dmmfm6j1g1oEiwBGz/
         RIF4pV/sq8d4RH+O7yNx9oWXUvStNVO+6fcPmNk5MdPNxisUnyqHoYRPd2G2wtt0zi1a
         ac42TxNipjXNIF6I9gFYIiEwzdgHVHBARQ9pkpjE74/58PrRi9T2lDIgvmTAnsf6Igqy
         +VKWq4+y9f0gbUv2sG61luNfYEL3XpEABknCcNIn88Zo+jilc8D8gFt9Aih2ykZYidy9
         ugpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMNhWn4/O57Tf5yTKD+cDvNEGJasCt6XyYAuj5ely1A=;
        b=Y6braJm1jtfPtrIXrYwcpac/rQokKAuWNJ3Nh/yua7RuU7TZ94gvJEqlnCe8WFTEOZ
         Ttec44ibZb1OQb8MbbY5jwBfhSUAp1265L0p2GHI3yJ642Ra0/4NafRiJglzkdJyH/3L
         0sR0nVBmzNklRVNcmoX0dg2Ehx7XeEbZJRNhFQcLRdpfn+0FX/pQSXqVxdkKu+O8TuQw
         VWx56Q/KC2kbe6cp5+c6LYhW02F6Bs3hXtvQrH6YUemme2CjK/PCW09qL1miPUOsLbdH
         HtfFHYjoOfOPJ/HKlHA1Sie3vH9DdUx/X2ROXGr1Oo9cZszh9+JzYoddOmTXoCI+fYJ1
         6dsA==
X-Gm-Message-State: ACrzQf1NYqcdqKBYvMVXOwkSNgJkP4dpam9Ck3ZNofLUKgXVj85jza+E
        JaWGOJ+gS4ZO7Ak8rXRiIjK+4K5emPc=
X-Google-Smtp-Source: AMsMyM6jmcXrAOkMMRJjRnVSQ5+ZavqPADIgtMGczeseojpYNJsj1k+RhiX9Q6zT2DBD2awYMfwq3w==
X-Received: by 2002:a05:6870:6086:b0:132:e9d6:ea36 with SMTP id t6-20020a056870608600b00132e9d6ea36mr19416370oae.116.1666111549755;
        Tue, 18 Oct 2022 09:45:49 -0700 (PDT)
Received: from ian.penurio.us ([47.184.52.85])
        by smtp.gmail.com with ESMTPSA id be36-20020a05687058a400b0012763819bcasm6356072oab.50.2022.10.18.09.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:45:48 -0700 (PDT)
From:   Ian Pilcher <arequipeno@gmail.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [RFC PATCH 0/1] libnftnl: Incorrect res_id byte order?
Date:   Tue, 18 Oct 2022 11:45:27 -0500
Message-Id: <20221018164528.250049-1-arequipeno@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am marking this as an RFC and including this cover letter, because
I'm not absolutely 100% sure that the current code is incorrect.  (It
obviously works, or this would have come up before.)

AFAICT, the res_id of struct nfgenmsg is supposed to be in network byte
order, and that isn't happening on little endian systems.
nftnl_batch_begin() and nftnl_batch_end() both pass NFNL_SUBSYS_NFTABLES
(10) to __nftnl_nlmsg_build_hdr(), but without a call to htons(), the
message contains 2560 (when interpretted in network byte order).

Ian Pilcher (1):
  libnftnl: Fix res_id byte order

 src/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


base-commit: 461f36979f4ed2b6cc95f06cf5f9c3c84bdf9e70
-- 
2.37.3

