Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D525C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 10:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089FD64E36
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 10:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhBCKRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 05:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhBCKRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 05:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 340B664E3E;
        Wed,  3 Feb 2021 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612347379;
        bh=JiQd1AVXeEdpEBGNqD2D+wZ+wH51zt/0P+o9Tb1P56c=;
        h=From:To:Cc:Subject:Date:From;
        b=gnN5UB9yoV5OXihVhGd5KxypFuR0QjRFq4L6Slxp+HQAnhEBHuScRHbXKEinyPa1H
         Voi4CAxi9qqVZTcBVb+tN+mHpZJXgrJLyzWtJgUF+j/ltj8KjjSacT2htWiKqsKkWz
         l1QCCdGQ0Hy55WjiHMNMpVEi/Yxd+zqgvG/uaQJexTtHSBiQIGfcx3yt+w07WaH2Dw
         hxW0zgqpuY5O1YfP+VKwDXsmQTyKYrcd9h8HSC8Geu2DWRa+f3AHemPoFsj3OX1NJs
         WyjsrbL8AkyLqsNexUxI49UXEfMw2bCD6TLVNXOzTo7Yh93lzaE11GFMDK5ZVVUHmf
         4mu+O0XFY2gmw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH net-next v1 0/4] Fix W=1 compilation warnings in net/* folder
Date:   Wed,  3 Feb 2021 12:16:08 +0200
Message-Id: <20210203101612.4004322-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Removed Fixes lines.
 * Changed target from net to be net-next.
 * Patch 1: Moved function declaration to be outside config instead
   games with if/endif.
 * Patch 3: Moved declarations to new header file.
v0: https://lore.kernel.org/lkml/20210202135544.3262383-1-leon@kernel.org
------------------------------------------------------------------
Hi,

This short series fixes W=1 compilation warnings which I experienced
when tried to compile net/* folder.

Thanks

Leon Romanovsky (4):
  ipv6: silence compilation warning for non-IPV6 builds
  ipv6: move udp declarations to net/udp.h
  net/core: move gro function declarations to separate header
  netfilter: move handlers to net/ip_vs.h

 include/linux/icmpv6.h          |  2 +-
 include/net/gro.h               | 12 ++++++++++++
 include/net/ip_vs.h             | 11 +++++++++++
 include/net/udp.h               |  3 +++
 net/core/dev.c                  |  7 +------
 net/ipv6/ip6_input.c            |  3 +--
 net/netfilter/ipvs/ip_vs_core.c | 12 ------------
 7 files changed, 29 insertions(+), 21 deletions(-)
 create mode 100644 include/net/gro.h

--
2.29.2

