From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/04]: Netfilter fixes
Date: Thu,  4 Sep 2008 16:15:53 +0200 (MEST)
Message-ID: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62486 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYIDOPz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:15:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following are four netfilter fixes for 2.6.27, containing:

- fix for a accidentally introduced static variable in the SIP helper
  that was intended to be local from Alexey

- a GRE helper keymap locking and list iteration fix from Alexey

- a patch to make the IRC helpers' port parsing more robust against the
  issues pointed out by Alexey

Please apply, thanks.


 net/netfilter/nf_conntrack_irc.c       |   10 ++++++++++
 net/netfilter/nf_conntrack_proto_gre.c |   14 +++++++++-----
 net/netfilter/nf_conntrack_sip.c       |    6 ++++--
 3 files changed, 23 insertions(+), 7 deletions(-)

Alexey Dobriyan (3):
      netfilter: nf_conntrack_sip: de-static helper pointers
      netfilter: nf_conntrack_gre: more locking around keymap list
      netfilter: nf_conntrack_gre: nf_ct_gre_keymap_flush() fixlet

Patrick McHardy (1):
      netfilter: nf_conntrack_irc: make sure string is terminated before calling simple_strtoul
