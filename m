From: "Horton, Dave" <dhorton@pactolus.com>
Subject: RE: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 21:38:34 -0400
Message-ID: <E8E029BA163C694484CFEA4914619EA206853DAA@pcsexch-bknet>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet> <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA5@pcsexch-bknet> <48DC3BAC.2090609@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	<netfilter-devel@vger.kernel.org>
To: "Philip Craig" <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host70.216.41.17.conversent.net ([216.41.17.70]:3996 "EHLO
	pcsexch.ad.pactolus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbYIZBif convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:38:35 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Standard nat rules can do that:
> iptables -t nat -A PREROUTING -p udp --dport start:end -j DNAT --to-
> destination newdest:newdestport
> iptables -t nat -A POSTROUTING -p udp -d newdest --dport newdestport
-j
> SNAT --to-source newsrc:newsrcport

Well, maybe I could use that, or more likely base my kernel module off
that code.  The reason that I probably can't use the DNAT target as is,
is because I also have to inspect the packets, and for some (very small)
number of them, send the packet up to userspace for further processing.
Also, my userspace process needs to frequently (hundreds of times per
second) change the forwarding rules, so for performance reasons I want
to specify those changes via commands over a netlink socket rather than
adding and removing iptables rules.

Does that make sense?  Should I be looking at creating a target similar
to DNAT, and using that code as reference?

