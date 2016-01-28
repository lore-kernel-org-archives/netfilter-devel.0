From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 00/11] revisiting protocol conflict resolution
Date: Thu, 28 Jan 2016 22:24:49 +0100
Message-ID: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43793 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbcA1VZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 526E261EBC
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 33D2BDA807
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BDA95DA7E0
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset revisits Florian's protocol conflict resolution to fully
support vlan matching without having to specify 'ether type vlan',
through our automatic dependency generation happening from the
evaluation step.

Patches from 1 to 7 are cleanups, then 8 to 11 deal with the problem
above.

To show you an example:

# nft --debug=netlink add rule netdev filter ingress \
	vlan id 1 ip saddr 10.0.0.0/23 udp dport 53 counter

generates the following bytecode:

netdev test-netdev ingress 
  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000100 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x0000000a ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000011 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00003500 ]
  [ counter pkts 0 bytes 0 ]

So the only addition wrt. to bridge are these two new instructions:

  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

that fetch the interface type and then check for ARPHRD_ETHER.

We can investigate later on if we can generalize the protocol context
code to deal with stackable headers in a more generic way. We can
discuss some idea during NetDev 1.1.

Thanks!

Pablo Neira Ayuso (11):
  evaluate: resolve_protocol_conflict() should return int
  evaluate: move inet/netdev protocol context supersede logic to supersede_dep()
  evaluate: check if we have to resolve a conflict in first place
  evaluate: don't adjust offset from resolve_protocol_conflict()
  evaluate: only try to replace dummy protocol from link-layer context
  evaluate: assert on invalid base in resolve_protocol_conflict()
  evaluate: wrap protocol context debunk into function
  evaluate: generate ether type payload after meta iiftype
  proto: proto_dev_type() returns interface type for base protocols too
  src: annotate follow up dependency just after killing another
  tests/py: test vlan on ingress

 src/evaluate.c                        | 133 +++++++++++--------
 src/netlink_delinearize.c             |  45 ++++---
 src/proto.c                           |  12 +-
 tests/py/bridge/vlan.t                |   2 +
 tests/py/bridge/vlan.t.payload.netdev | 235 ++++++++++++++++++++++++++++++++++
 5 files changed, 355 insertions(+), 72 deletions(-)
 create mode 100644 tests/py/bridge/vlan.t.payload.netdev

-- 
2.1.4

