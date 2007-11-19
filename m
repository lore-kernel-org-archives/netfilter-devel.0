From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv4 0/2] Find address type on the packet's interface
Date: Mon, 19 Nov 2007 16:55:45 +0100
Message-ID: <11954877483732-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52359 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbXKSPzy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:55:54 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 1A66AC15E2
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Nov 2007 16:55:52 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

This extension of addrtype match lets the address type checking be
limited to the incoming or outgoing interface of the packets depending
on the current hook.

In the FORWARD chain only one check is allowed but the user can choose
which one would like to specifiy.

Because of this extension the match has a new revision. Rev 0 can be
used by older tools and rev 1 is for the modified iptables match.

The iptables patch is for revision 1 only.

Both the kernel module and the iptables module moved to xtables,
but the kernel module uses ipt_addrtype_info in revision 0.

Usage:
  iptables -A INPUT -m addrtype ... --limit-iface-in -j ACCEPT
  iptables -A OUTPUT -m addrtype ... --limit-iface-out -j ACCEPT
  # 2 rules in the FORWARD chain
  iptables -A FORWARD -m addrtype ... --limit-iface-in -j ACCEPT
  iptables -A FORWARD -m addrtype ... --limit-iface-out -j ACCEPT

Patches:
 [kernel 1/2] Find address type on a specific or on any interface
 [kernel 2/2] Addrtype match: limit addrtype check to an interface.
      Moved to xtables
 [iptables] Adress type match: limited to incoming or outgoing interface.
      Moved to xtables

Regards,
  Attila
