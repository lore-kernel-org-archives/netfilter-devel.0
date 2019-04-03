Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E673C10F06
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6916B2054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfDCPkK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:10 -0400
Received: from mail.us.es ([193.147.175.20]:56646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfDCPkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3051D172C8E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FA6DDA713
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 12563DA78C; Wed,  3 Apr 2019 17:40:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D821EDA70B;
        Wed,  3 Apr 2019 17:40:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 949AF4265A31;
        Wed,  3 Apr 2019 17:40:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 0/8] connection tracking support for bridge
Date:   Wed,  3 Apr 2019 17:39:53 +0200
Message-Id: <20190403154001.8177-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset provides native connection tracking support for bridge,
*this is work-in-progress RFC*.

ebtables has a very limited feature-set compared to iptables, among them
no connection tracking support. Long time ago, to overcome this
limitation, someone came up with the bridge netfilter infrastructure -
the `br_netfilter' kernel module. This module steals frames from bridge
prerouting hook, mangle them to make them look like IPv4 packets to
make iptables happy, eg. by attaching a fake dst object, then inject
them into the IP hooks, then take them back into the bridge frame layout
to call the bridge routines. Going back and forth through all the
netfilter IP and bridge hooks, not nice. In turn, this `br_netfilter'
infrastructure has been allowing users to use iptables, conntrack and
NAT for bridged frames, instead of ebtables. An iptables extension
called 'physdev' was introduced at the time to match on the bridge
interface as a way to expose some of the semantics behind this emulation
layer.

However, along time, many design problems uncovered with this
`br_netfilter' emulation, becoming a common topic of discussion.

This patchset is an initial step to introduce a replacement for this
`br_netfilter' emulation layer by introducing one of the missing
features that makes users turn on this `br_netfilter' emulation layer.

This patchset includes updates to expose two new refragmentation APIs in
order to reuse them from the bridge. The existing ip_do_fragment() calls
rely on dst objects that are not available from there, this function
also triggers refragmentation where the maximum fragment size is larger
than the device MTU, altering fragments geometry in that case, something
that a bridge should not do, among other things. I think this new
refragment infrastructure could be reused by folks with codebase away
from the classic IP stack, eg. OVS.

Comments welcome, thanks.

Pablo Neira Ayuso (8):
  net: use kfree_skb_list() from ip_do_fragment()
  net: ipv4: add skbuff fraglist split iterator
  net: ipv6: add skbuff fraglist split iterator
  net: ipv4: split skbuff into fragments transformer
  net: ipv6: split skbuff into fragments transformer
  net: ipv4: place cb handling away from fraglist iterator
  net: ipv4: place cb handling away from fragment transformer
  netfilter: bridge: add basic conntrack support

 include/net/ip.h                           |  39 +++
 include/net/ipv6.h                         |  44 +++
 net/bridge/br_private.h                    |   2 +-
 net/bridge/netfilter/Kconfig               |  14 +
 net/bridge/netfilter/Makefile              |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 411 +++++++++++++++++++++++++++++
 net/ipv4/ip_output.c                       | 314 +++++++++++++---------
 net/ipv6/ip6_output.c                      | 315 +++++++++++++---------
 8 files changed, 884 insertions(+), 258 deletions(-)
 create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c

-- 
2.11.0

