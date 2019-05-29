Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2A8C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 11:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F188820B1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 11:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfE2LZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 07:25:51 -0400
Received: from mail.us.es ([193.147.175.20]:52960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfE2LZv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 07:25:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32095C1B63
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 13:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DE42DA708
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 13:25:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D265DA707; Wed, 29 May 2019 13:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDEEEDA70D;
        Wed, 29 May 2019 13:25:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 13:25:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9AA6840705C5;
        Wed, 29 May 2019 13:25:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH net-next,v3 0/9] connection tracking support for bridge
Date:   Wed, 29 May 2019 13:25:30 +0200
Message-Id: <20190529112539.2126-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds native connection tracking support for the bridge.

Patch #1 and #2 extract code from IPv4/IPv6 fragmentation core and
introduce the fraglist splitter. That splits a skbuff fraglist into
independent fragments.

Patch #3 and #4 also extract code from IPv4/IPv6 fragmentation core
and introduce the skbuff into fragments transformer. This can be used
by linearized skbuffs (eg. coming from nfqueue and ct helpers) as well
as cloned skbuffs (that are either seen either with taps or with bridge
port flooding).

Patch #5 moves the specific IPCB() code from these new fragment
splitter/transformer APIs into the IPv4 stack. The bridge has a
different control buffer layout and it starts using this new APIs in
this patchset.

Patch #6 adds basic infrastructure that allows to register bridge
conntrack support.

Patch #7 adds bridge conntrack support (only for IPv4 in this patch).

Patch #8 adds IPv6 support for the bridge conntrack support.

Patch #9 registers the IPv4/IPv6 conntrack hooks in case the bridge
conntrack is used to deal with local traffic, ie. prerouting -> input
bridge hook path. This cover the bridge interface has a IP address
scenario.

Before this patchset, only chance for people to do stateful filtering is
to use the `br_netfilter` emulation layer, that turns bridge frame into
IPv4/IPv6 packets and inject them into the IPv4/IPv6 hooks. Apparently,
this module allows users to use iptables and all of its feature-set from
the bridge, including stateful filtering. However, this approach is
flawed in many aspects that have been discussed many times. This is a
step forward to deprecate `br_netfilter'.

v2: Fix English typo in commit message.
v3: Fix another English typo in commit message.

Please, apply. Thanks.

Pablo Neira Ayuso (9):
  net: ipv4: add skbuff fraglist splitter
  net: ipv6: add skbuff fraglist splitter
  net: ipv4: split skbuff into fragments transformer
  net: ipv6: split skbuff into fragments transformer
  net: ipv4: place control buffer handling away from fragmentation iterators
  netfilter: nf_conntrack: allow to register bridge support
  netfilter: bridge: add connection tracking system
  netfilter: nf_conntrack_bridge: add support for IPv6
  netfilter: nf_conntrack_bridge: register inet conntrack for bridge

 include/linux/netfilter_ipv6.h              |  50 ++++
 include/net/ip.h                            |  39 +++
 include/net/ipv6.h                          |  44 +++
 include/net/netfilter/nf_conntrack.h        |   1 +
 include/net/netfilter/nf_conntrack_bridge.h |  20 ++
 include/net/netfilter/nf_conntrack_core.h   |   3 +
 net/bridge/br_device.c                      |   1 +
 net/bridge/br_private.h                     |   1 +
 net/bridge/netfilter/Kconfig                |  14 +
 net/bridge/netfilter/Makefile               |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c  | 433 ++++++++++++++++++++++++++++
 net/ipv4/ip_output.c                        | 309 ++++++++++++--------
 net/ipv6/ip6_output.c                       | 315 +++++++++++---------
 net/ipv6/netfilter.c                        | 123 ++++++++
 net/netfilter/nf_conntrack_proto.c          | 126 ++++++--
 15 files changed, 1206 insertions(+), 276 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bridge.h
 create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c

-- 
2.11.0

