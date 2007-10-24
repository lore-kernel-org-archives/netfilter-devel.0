From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv2 0/2] Find address type on the packet's interface
Date: Wed, 24 Oct 2007 16:21:28 +0200
Message-ID: <11932356911253-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51469 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbXJXOVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:21:37 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 51599C1159
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Oct 2007 16:21:35 +0200 (CEST)
Message-Id: <20071024-160736-1193234856.pather@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

This extension of ipt_addrtype match lets the address type checking be
limited to the incoming or outgoing interface of the packets except in
the FORWARD hook because either incoming or outgouing interface could
be used.

Because of this extension the match has a new revision. Rev 0 can be
used by older tools and rev 1 is for the modified iptables match.
The latter one is for revision 1 only.

Usage:
iptables .... -m addrtype --...-type ... --limit-iface ...


Regards,
  Attila
