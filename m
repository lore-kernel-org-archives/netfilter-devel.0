From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 00/69]: Netfilter Update
Date: Wed, 30 Jan 2008 21:55:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801302153450.3599@fbirervta.pbzchgretzou.qr>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40373 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYA3Uz0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:55:26 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 30 2008 21:16, Patrick McHardy wrote:
>
>following is the final netfilter update for 2.6.25. containing the iptables
>netns work by Alexey Dobriyan, lots of sparse warning fixes by Stephen, Eric
>and myself, const annotations throughout netfilter by Jan Engelhardt,
>a set of patches to finally use RCU for the conntrack and NAT hashes, some
>conntrack optimizations and some minor misc cleanups.

What do people use to apply this batch? I exported them into an MBOX
and tried git-am, but that always uses the mail's From: and Subject:
rather than the --raw patch after the three-dashes.
