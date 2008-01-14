From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 16:20:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801141618030.10906@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
 <478AFB75.7040701@trash.net> <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
 <478B310A.3040300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59532 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYANPUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:20:52 -0500
In-Reply-To: <478B310A.3040300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 14 2008 10:53, Patrick McHardy wrote:

> But adding a new chain to the raw table is a high price, every new
> netfilter hooks costs quite a bit of performance. Why not simply do
> this in the mangle table? That will also make rerouting in OUTPUT
> work as a side effect.

I think the issue that I tried to outrun was that if I mangle the
address in NF_IP_PRI_MANGLE, then IP_NF_PRI_CONNTRACK_HELPER and
IP_NF_PRI_CONNTRACK_CONFIRM gets confused because I change the
address after NF_IP_PRI_CONNTRACK.

IOW: conntrack sees the packet, I mangle it in mangle,
and then the other conntrack hooks get confused.
That is why I thought I need some hook after
NF_IP_PRI_CONNTRACK_CONFIRM.
