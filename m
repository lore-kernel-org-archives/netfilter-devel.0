Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE2AC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3892020700
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="QcBL/Lrr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbfCZU5f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:57:35 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21025 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbfCZU5f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:57:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553633849; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=TuhUDwEcItM13AHjI074bMLc5nmRIwDWBeD9gfSaMa5ENIKm/u2X/yioYiB9zm0ZArK/FGrULiktJMfnJcBd9b/X8Qb2SP/sF67cHLZDpoOy04m16VhXjUApHWoH5oRytu05LlmS43QdV6nudCvKxO9ohErpfe+Wacab6tbkK7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553633849; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=8oDufr+e7RhX5V+j72NJd59UKhJ5hOfwi0CmHeyJxBo=; 
        b=caiTj/9Yl2jJ92I3gQZ7YBZyn8EZ0qtvUIZ7nGruXvHvxztYAAcL7H/i7GURJDFD7abR3QY37Hb3KmClyLyDm6W1Cp4a4acPxfobvmlQD4CsP2w3iewDqOl267U4y8ZrCMj2RDEJY4N5/qQ6O2tr/adxfTrvogWSIdwVoMcpm3s=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553633849;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1725; bh=8oDufr+e7RhX5V+j72NJd59UKhJ5hOfwi0CmHeyJxBo=;
        b=QcBL/LrrhkJbK4Z2JDCOIGZgauJqS7wVMa1Ela9EWb5t4puf7O6YAlxDwakHHfsg
        TAfiSGWp83m1+rmcgABxajp3muHtr+UIbprgQsSY5vONw2kM4LoofRFFBaE6eJb9S3Q
        HWHXy3FejDdOUDHrSNVaRtAzQaxMctJCjKiwZpdY=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 1553633847132122.76906785349684; Tue, 26 Mar 2019 13:57:27 -0700 (PDT)
From:   Flavio Leitner <fbl@sysclose.org>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Message-ID: <20190326205715.22288-1-fbl@sysclose.org>
Subject: [PATCH net-next 0/8] openvswitch: load and reference the NAT helper.
Date:   Tue, 26 Mar 2019 17:57:07 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
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

 include/net/netfilter/nf_conntrack_helper.h |  23 ++++-
 net/ipv4/netfilter/nf_nat_h323.c            |   2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |   2 +-
 net/netfilter/nf_conntrack_amanda.c         |   2 +
 net/netfilter/nf_conntrack_ftp.c            |   6 +-
 net/netfilter/nf_conntrack_helper.c         | 108 +++++++++++++++++++-
 net/netfilter/nf_conntrack_irc.c            |   3 +-
 net/netfilter/nf_conntrack_sane.c           |   4 +-
 net/netfilter/nf_conntrack_sip.c            |  12 ++-
 net/netfilter/nf_conntrack_tftp.c           |   6 +-
 net/netfilter/nf_nat_amanda.c               |   9 +-
 net/netfilter/nf_nat_ftp.c                  |   8 +-
 net/netfilter/nf_nat_irc.c                  |   8 +-
 net/netfilter/nf_nat_sip.c                  |   8 +-
 net/netfilter/nf_nat_tftp.c                 |   8 +-
 net/openvswitch/conntrack.c                 |  27 +++--
 16 files changed, 209 insertions(+), 27 deletions(-)

--=20
2.20.1



