From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [rfc] using xor in mark targets
Date: Thu, 29 Nov 2007 23:50:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbXK2Wui (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:50:38 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id D12991C06E87B
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 23:50:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


the usual MARK targets all have something like:

	newmark = (oldmark & ~mask) | newmark;

in Fall 2007's tproxy patches, the following is used instead:

	newmark = (oldmark & ~mask) ^ newmark;

this puzzled me at first but looks well-thought. The new xt_TOS
already uses the XOR variant, to get that extra bit of expressive
power[1].

I would have liked to do the same for MARK, but I suspect it is not
quite backwards-compatible with respect to user scripts and
iptables-save output. So what could be done?
	* -j MARK2 --set-mark 0x81/0x7F
	* -j MARK --set-mark-v2 0x81/0x7F
other ideas, thoughts, criticism?


[1] http://www.spinics.net/lists/netfilter-devel/msg00050.html
