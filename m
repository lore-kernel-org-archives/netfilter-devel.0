From: Jan Engelhardt <jengelh@medozas.de>
Subject: kernel/iptables patches
Date: Fri,  8 May 2009 11:26:30 +0200
Message-ID: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53344 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbZEHJ0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


please apply the following tidbits for the kernel-side iptables code.
Alternatively, the set is provided at
	git://dev.medozas.de/linux master
with base dave/master:v2.6.30-rc1-1016-g928f308.


Jan Engelhardt (10):
      netfilter: xtables: use NFPROTO_ for xt_proto_init callsites
      netfilter: queue: use NFPROTO_ for queue callsites
      netfilter: xtables: use NFPROTO_ in standard targets
      netfilter: xtables: remove redundant casts
      netfilter: xtables: fix const inconsistency
      netfilter: xtables: consolidate open-coded logic
      netfilter: xtables: reduce indent level by one
      netfilter: xtables: remove some goto
      netfilter: xtables: remove another level of indent
      netfilter: xtables: consolidate comefrom debug cast access

These transforms are part of an ongoing investigation on how to
consolidate the *tables, and making it a bit more readable seemed the
first step. The patches seem useful independently nevertheless.
