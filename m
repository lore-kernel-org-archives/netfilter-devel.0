Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC21C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C02820870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfDMXR1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35851 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfDMXR1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so15363540qtn.3
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qigw1/fYpSP+rupwhsHk5zqSFeFLKdWOEKLPFdwdDuU=;
        b=mcqebhkV9emRCr7yDyU+LjWVpm2LoN3T+eWNXDgTCjMmv2qyCVh4hwuv2TXfAA5IS0
         luQf74neQg+50nNnnsLWSaVzT/o21cbYNnq+gPW1NJCO0yNvKKbyDWd39etVGZTPvX+l
         xdTqeRj92R8uqdWKsxMvh+lQKJcNlvpIl/r0Jf+Jf58a/Je4hofCdWSBRCWO/WYiBizS
         og/83vBdwATG52jRmQ2vg77eI2tlMpEyB/q/mBbhM7cm3NhzlWQjgR68+t9Th3fl2CAy
         edhdn3FVCPxiOwcgvF0WlWg/Baq1w0eJ6DhTfnNAe1m29hAJa1WIuWDQyrnzh/W28KrJ
         dbSQ==
X-Gm-Message-State: APjAAAWaAfhQcoY2c8y1ffb8/EWuzJ1fq1rADy9Yk0waohYp1vffDo0M
        snrfh8DWqRvhlOc7rJjKnfbZKw==
X-Google-Smtp-Source: APXvYqxD8tPxDh0pBKbzA1VfGYFOloy1pfHR8Vuu7hsA65JIX0BmOC+0U+3NO7mTo6j+1z5L9E39xQ==
X-Received: by 2002:aed:3aaa:: with SMTP id o39mr54808558qte.100.1555197446440;
        Sat, 13 Apr 2019 16:17:26 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id n188sm25017212qkb.40.2019.04.13.16.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:25 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 0/8] openvswitch: load and reference the NAT helper
Date:   Sat, 13 Apr 2019 20:17:08 -0300
Message-Id: <20190413231716.28711-1-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The request_module() is quite expensive and triggers the
usermode helper in userspace. Instead, load only if the
module is not present and keep module references to avoid
problems.

The first patch standardize the module alias which is already
there, but not in a formal way.

The second patch adds an API to point to the NAT helper.

The following patches will register each NAT helper using
the new API.

The last patch fixes openvswitch to use the new API to
load and reference the NAT helper and also report an error
if the operation fails.

Flavio Leitner (8):
  netfilter: use macros to create module aliases.
  netfilter: add API to manage NAT helpers.
  netfilter: nf_nat: register amanda NAT helper.
  netfilter: nf_nat: register ftp NAT helper.
  netfilter: nf_nat: register irc NAT helper.
  netfilter: nf_nat: register sip NAT helper.
  netfilter: nf_nat: register tftp NAT helper.
  openvswitch: load and reference the NAT helper.

 include/net/netfilter/nf_conntrack_helper.h | 24 +++++
 net/ipv4/netfilter/nf_nat_h323.c            |  2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  8 +-
 net/netfilter/nf_conntrack_ftp.c            | 13 +--
 net/netfilter/nf_conntrack_helper.c         | 97 +++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  6 +-
 net/netfilter/nf_conntrack_sane.c           | 12 +--
 net/netfilter/nf_conntrack_sip.c            | 28 +++---
 net/netfilter/nf_conntrack_tftp.c           | 18 ++--
 net/netfilter/nf_nat_amanda.c               |  9 +-
 net/netfilter/nf_nat_ftp.c                  |  9 +-
 net/netfilter/nf_nat_irc.c                  |  9 +-
 net/netfilter/nf_nat_sip.c                  |  9 +-
 net/netfilter/nf_nat_tftp.c                 |  9 +-
 net/openvswitch/conntrack.c                 | 26 ++++--
 16 files changed, 233 insertions(+), 48 deletions(-)

-- 
2.20.1

