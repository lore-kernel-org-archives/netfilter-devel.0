Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CE4C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CDA2070B
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgEFJqn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 05:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726935AbgEFJqn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 05:46:43 -0400
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCDDC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 02:46:42 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id DA8DB200DA;
        Wed,  6 May 2020 11:46:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id A61F16219;
        Wed,  6 May 2020 11:46:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EqAJFgXxQKst; Wed,  6 May 2020 11:46:34 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Wed,  6 May 2020 11:46:33 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id C1166306A950; Wed,  6 May 2020 11:46:33 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 0/3] Avoid gretap fragmentation with nftables on bridge
Date:   Wed,  6 May 2020 11:46:22 +0200
Message-Id: <cover.1588758255.git.michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have a bridge with connects an gretap tunnel with some ethernet lan.
On the gretap device I use ignore-df to avoid packets being lost without
icmp reject to the sender of the bridged packet.

Still I want to avoid packet fragmentation with the gretap packets.
So I though about adding an nftables rule like this:

nft insert rule bridge filter FORWARD \
  ip protocol tcp \
  ip length > 1400 \
  ip frag-off & 0x4000 != 0 \
  reject with icmp type frag-needed

This would reject all tcp packets with ip dont-fragment bit set that are
bigger than some threshold (here 1400 bytes). The sender would then receive
ICMP unreachable - fragmentation needed and reduce its packet size (as
defined with PMTU).

This patch series
 1. adds frag-needed ipv4 flag to nftables
 2. enables to use this with bridge vlans.

For IPv6, this would need ICMPV6_PKT_TOOBIG instead of ICMPV6_DEST_UNREACH
in nft_reject_br_send_v6_unreach, so this is not part of this series.

Regards,
M. Braun

-- 
2.20.1

