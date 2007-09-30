From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 1 Oct 2007 00:50:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710010049420.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205335.10969.91031.stgit@nessa.odu> <470026AF.5060404@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@sch.bme.hu>,
	netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33266 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXI3Wub (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:50:31 -0400
In-Reply-To: <470026AF.5060404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 1 2007 00:43, Patrick McHardy wrote:
>
> All this compat stuff becomes unnecessary with fixed size types.

Fixed size types alone won't do it. Think 64-bit. You would have
{32, 16, 32, 32}, and I would be pretty sure they pad it up to
{32, 16, [16], 32, 32}. Well, see my version, which avoids that :)
