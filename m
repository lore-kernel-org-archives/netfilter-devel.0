Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A69FC10F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1682070D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfDOVgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:36:24 -0400
Received: from mail.us.es ([193.147.175.20]:48220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfDOVgX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 17:36:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2EB272EFEAF
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 23:36:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 193BEDA712
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 23:36:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0EB36DA70C; Mon, 15 Apr 2019 23:36:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4512DA702;
        Mon, 15 Apr 2019 23:36:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 23:36:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 846A24265A31;
        Mon, 15 Apr 2019 23:36:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, fw@strlen.de,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        herbert@gondor.apana.org.au
Subject: [PATCH net-next 00/10] connection tracking support for bridge
Date:   Mon, 15 Apr 2019 23:36:01 +0200
Message-Id: <20190415213611.21863-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset add connection tracking support for the bridge family.

Patches from 1 to 6 split the existing refragmentation codebase into
smaller functions that allows us to build specific refragmentation
routine for the bridge, motivations for this are:

* ip_do_fragment() assumes the skbuff is called from IP stack,
  hence the control buffer area is assumed to have an IP_CB layout,
  this forces to save and restore this area.

* ip_do_fragment() assumes that a dst entry is attached to the
  skbuff which is not the case from the bridge codebase. This would
  force us to emulate a dst object.

* ip_do_fragment() alters fragmentation geometry to make it fit into
  the mtu. From the bridge, it is desiderable to leave geometry
  untouched, simply drop packets if the maximum fragment size is larger
  than the mtu. There are a few exceptions in this patchset though, such
  as linearized skbuff (coming from conntrack helpers doing so) where
  geometry is lost for us, and for cloned skbuffs, either due to port
  flood or passed up for tap delivery.  For both cases, it should be
  possible with a more code and the cost of introducing more complexity.

These initial patches extract code from the existing refragmentation
infrastructure that can be re-used to build a custom refragmentation
routine that deals with the bridge specificities. This batch is composed
of the following patches:

* Patches 1/10 and 2/10 add the fraglist iterator. This infrastructure
  extracts the code from ip_do_fragment() to split a fraglist into
  fragments, then call the output callback for each fragmented skbuff.
  The API consists of ip_fraglist_init() to start the iterator internal
  state, then ip_fraglist_prepare() to restore restore the IPv4 header
  in the fragment and, finally, ip_fraglist_next() to obtain the
  fragmented skbuff from the fraglist. Similar API is introduced for
  IPv6.

* Patches 3/10 and 4/10 add the fragment transformer. This
  infrastructure extracts the code from ip_do_fragment() to split a
  linearized skbuff into fragmented skbuffs. This is also useful for the
  skbuff clone case, needed in case of floods to multiple bridge ports
  or when passing packets to the tap (ie. tcpdump), so this transformer
  can also deal with fraglists. The API consists of ip6_frag_init() to
  start the internal state of the transformer and ip6_frag_next() to build
  and fetch a fragment.

* Patches 5/10 and 6/10 move the IPCB specific code away from these two
  new APIs, so it can be used from the bridge without saving and
  restoring the control buffer area.

After preparation patches, this batch adds the conntrack support for the
bridge family:

* Patch 7/10 adds infrastructure to register and to unregister the
  nf_conntrack_bridge module via nf_ct_bridge_register() and
  nf_ct_bridge_unregister(). This allows us to transparently reuse
  the ct extension to match on the ct state without changes.

* Patch 8/10 adds IPv4 conntrack support for bridge. This add the
  nf_conntrack_bridge module which registers two hooks, one at
  bridge prerouting and another at bridge postrouting. For traffic that
  is being forwarded, a conntrack entry is created at bridge prerouting
  and confirmed at bridge postrouting. ARP packets are explicitly
  untracked. We also follow the "do not drop packets from conntrack", as
  invalid packets can be just dropped via policy.

* Patch 9/10 adds IPv6 support for conntrack bridge.

* Patch 10/10 enables classic IPv4/IPv6 conntrack to deal with local
  traffic, ie. when the bridge interface has an IP address, hence
  packets are passed up to the IP stack for local handling are confirmed
  by the classic IPv4/IPv6 conntrack hooks. This allows users to define
  stateful filtering policies from the bridge prerouting chain. For
  outgoing traffic, the recommended solution is to define the stateful
  policy from the classic IPv4/IPv6 output hooks.

Users can map different vlans to conntrack zones to avoid conflicts with
overlapping conntrack entries via ruleset policy.

Please, apply, thanks!

Pablo Neira Ayuso (10):
  net: ipv4: add skbuff fraglist split iterator
  net: ipv6: add skbuff fraglist split iterator
  net: ipv4: split skbuff into fragments transformer
  net: ipv6: split skbuff into fragments transformer
  net: ipv4: place cb handling away from fraglist iterator
  net: ipv4: place cb handling away from fragment transformer
  netfilter: nf_conntrack: allow to register bridge support
  netfilter: bridge: add support for conntrack support
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

