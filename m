Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8DAC282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12D262173C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbfDQOq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:46:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42533 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731844AbfDQOq3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:46:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id p20so27591591qtc.9
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qHJbV3TuW3vx0wZSan1t46+kpgP+ZsSQnJpJ9c9MTA=;
        b=BZczq/+bWpfRwxoFkAHO6dpGVCcpjsYHjYz7MmNpoflCmSwlw47cDB30ZQVrLHFDYh
         dUoWA6ulOO/2oEEvgyIjrjlANH7lkYo/5IOfku/nnIRznOgfAUqpl03OL+yfOPpYA6kK
         z1Cj88Z+mCMjV4SqAspjrLmyMP9DQZJzEh5ggEHXL4tiRbdlTvLk+BkP+/bozwncZPwj
         ZGBcO0xa9svP0zba7mDgnHaBaeRwx7eDDx7AWFJirpT3lQ0aEMi+RQEgnIgYitxHh798
         TSdbt7I5sBL44vm5FwrAYilBxCGzM6CWb5CbubNtO0iN5ZI/KYiO8wRpdTH5Rex9S9fu
         kQ8A==
X-Gm-Message-State: APjAAAUI10ou3IdUWb+gV0LLu9XnPuhUBkBNhIyG5tJgN9fkVF/WZA8h
        pja8RtrAaBbmyZsxdl9Qx1D1H0mTZOo=
X-Google-Smtp-Source: APXvYqziUDSjyvrG0ldtfBW4ENVQUWC0dTgYjI+vT+pfWUqfMjrnVioBsR8VmqeDAfj+yBinSkJw3w==
X-Received: by 2002:ac8:1833:: with SMTP id q48mr71252892qtj.133.1555512388465;
        Wed, 17 Apr 2019 07:46:28 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id p6sm39900950qtk.70.2019.04.17.07.46.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 07:46:27 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v3 0/4] openvswitch: load and reference the NAT helper
Date:   Wed, 17 Apr 2019 11:46:13 -0300
Message-Id: <20190417144617.14922-1-fbl@redhat.com>
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

The third patch will register each NAT helper using the
new API.

The last patch fixes openvswitch to use the new API to
load and reference the NAT helper and also report an error
if the operation fails.


Flavio Leitner (4):
  netfilter: use macros to create module aliases.
  netfilter: add API to manage NAT helpers.
  netfilter: nf_nat: register NAT helpers.
  openvswitch: load and reference the NAT helper.

 include/net/netfilter/nf_conntrack_helper.h | 24 ++++++
 net/ipv4/netfilter/nf_nat_h323.c            |  2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  8 +-
 net/netfilter/nf_conntrack_ftp.c            | 18 +++--
 net/netfilter/nf_conntrack_helper.c         | 86 +++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  6 +-
 net/netfilter/nf_conntrack_sane.c           | 12 +--
 net/netfilter/nf_conntrack_sip.c            | 28 +++----
 net/netfilter/nf_conntrack_tftp.c           | 18 +++--
 net/netfilter/nf_nat_amanda.c               |  9 ++-
 net/netfilter/nf_nat_ftp.c                  |  9 ++-
 net/netfilter/nf_nat_irc.c                  |  9 ++-
 net/netfilter/nf_nat_sip.c                  |  9 ++-
 net/netfilter/nf_nat_tftp.c                 |  9 ++-
 net/openvswitch/conntrack.c                 | 26 +++++--
 16 files changed, 225 insertions(+), 50 deletions(-)

-- 
2.20.1

