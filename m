Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CEEECAAD4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 03:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiIADGp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 23:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiIADGZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 23:06:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A380E8698
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 20:06:18 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n8-20020a17090a73c800b001fd832b54f6so1247253pjk.0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 20:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=jzys6zYw+Q1prsW6OWxyYvYOSLZd2kL6s95paGupV2g=;
        b=F5nSQkcMwejQysNXHC8CODiyUdITMnG0y4pu5ezM7eQhyrOkVf8jYUGpo+uxfb5E2w
         W0YMBn1yRnYHaR1uQodK+elIfSQQhzjkfXuJnl7IS6lwrpLXbtxK8E6M9Vno1fwWoMNk
         b8NuNowjd9h+6EFiay8NfIbamRPLv5JkXrsoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=jzys6zYw+Q1prsW6OWxyYvYOSLZd2kL6s95paGupV2g=;
        b=AQy6vxcXKQPnsn033zo+HsAyp5K6DgeVGQPrE3qvbfDUTKgtiGQ9KOqWDgiikQo9Cq
         M7TCF6lljTseL9MdyWIwRr4U/fmhxWV4HBjKdSR+CAy2gi/d0xHv+1zzNHGz9vInX5gl
         tpgZ5c40N14fCRGWnck91WsmT8/uBwP4aCe7bBegyKeOJ5oWK/zKuKUKYxmZaV4nMqqQ
         2UHALlFVQ6pu++yuarMvv5NZTmempHEwz58xZc5quJRD7TTxtIuvHhgOFL/uoo33DPhC
         S7sBeXETNj6j/FllxzmMnmwmo8wRneSv96Vk0skUzUai6LdEi5qmiXFThnnm4rL+jIS/
         AnAw==
X-Gm-Message-State: ACgBeo3mk5gEtn1RLtvWq2qRvdruh0qu/wIdTCwUoU43kpYQZagLoBJ0
        m3WrxuArwJvkLKKy3hwDk1b20g==
X-Google-Smtp-Source: AA6agR7Sw+dqFlOTeUmZaBwOiuN/kmajQej38R1obITTaafcexZiEYqlr48/2rV64Jg66rGyJ7IGUQ==
X-Received: by 2002:a17:90b:293:b0:1fd:7caa:e324 with SMTP id az19-20020a17090b029300b001fd7caae324mr6512598pjb.11.1662001577713;
        Wed, 31 Aug 2022 20:06:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q63-20020a634342000000b0042bea8405a3sm4027035pga.14.2022.08.31.20.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 20:06:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzkaller@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/2] netlink: Bounds-check struct nlmsgerr creation
Date:   Wed, 31 Aug 2022 20:06:08 -0700
Message-Id: <20220901030610.1121299-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=711; h=from:subject; bh=AnHz3m3mc0z+GZYjU6Piduca0GteHs1YZz+sSzFG5+Y=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjECGh7nSUR2+OcGMxUlRYtLO5qXb0hG272l98gx5I 0dRnn7aJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxAhoQAKCRCJcvTf3G3AJi9zD/ 9Y789r9orV98vIr8AJnnmPwd42aVbjUD0uuHQMvUOaB2uwFrsuer7Vj9UlBZpFabqvSUoktYZAkAXM M7zbZN/1K3fIWBczSXU30vjTEy3IhbQVQjYutjnN10gwX4c+dLp3TJI+J5JhPI4xJlp/zcdVv2ueh5 qdm8MphncPkPbftKkJUIIOi9wmooz1AyTHH10CXz6oFZ+ATk6lwMEzvFW0pF8cE/E9juA9bogtvLC8 XD07LfP2xRV3GZT77FzIvVlvY8W5ifHjA3lOaiJ9MY905mklwQ+5ZDmDyBwzMqstNl2aouoFIKmcYU O2VpuVaKH/k4QL2oKPIiR5ep8E0Drb4QYby9ZNKX6PjpVEd9y+wqN+cEyfaRzblIwMTYYdOsP7THKR zhBB64gJJdRrH3qKetnto0g+9JVUBPcL/57cAbny3NdMMUOt/pLWZnpHXEWZOL+DBG28b0o5vwP+TI uFpQXIrQp+hyes/kL7UnXCunvpcWQm0T9BQUOH/yYVtIjKjX7w0KyPNmKrAr+VOzj0v+/IOWZe4I1f CPxmSKfcaYUME1wxX27uPbsHI0zxdJJlHfF4/T8iFf5QkMtmrCFMirB6ORwxA698IfFf2bDzH0cSGi MDeSpINnYWiug34OUnzNUB8BpzuXeeaZMZazcZKdX9B4L0hc1S5zccLOtPPg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

In order to avoid triggering the coming runtime memcpy() bounds checking,
the length of the destination needs to be "visible" to the compiler in
some way. However, netlink is constructed in a rather hidden fashion,
and my attempts to wrangle it have resulted in this series, which perform
explicit bounds checking before using unsafe_memcpy().

-Kees

Kees Cook (2):
  netlink: Bounds-check nlmsg_len()
  netlink: Bounds-check struct nlmsgerr creation

 include/net/netlink.h             | 10 ++++++-
 net/netfilter/ipset/ip_set_core.c | 10 +++++--
 net/netlink/af_netlink.c          | 49 +++++++++++++++++++++----------
 3 files changed, 49 insertions(+), 20 deletions(-)

-- 
2.34.1

