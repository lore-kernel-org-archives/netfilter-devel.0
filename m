From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv3 0/2+1] Find address type on the packet's interface
Date: Thu, 15 Nov 2007 18:14:07 +0100
Message-ID: <11951468501800-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:42368 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbXKOROQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:14:16 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 7878FC12C0
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2007 18:14:14 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

This extension of ipt_addrtype match lets the address type checking be
limited to the incoming or outgoing interface of the packets depending
on the current hook.

In the FORWARD chain only one check is allowed but the user can choose
which one would like to specifiy.

Because of this extension the match has a new revision. Rev 0 can be
used by older tools and rev 1 is for the modified iptables match.

The iptables patch is for revision 1 only.

Usage:
  iptables -A INPUT -m addrtype ... --limit-iface-in -j ACCEPT
  iptables -A OUTPUT -m addrtype ... --limit-iface-out -j ACCEPT
  # 2 rules in the FORWARD chain
  iptables -A FORWARD -m addrtype ... --limit-iface-in -j ACCEPT
  iptables -A FORWARD -m addrtype ... --limit-iface-out -j ACCEPT

Regards,
  Attila
