From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Sun, 18 May 2008 04:25:17 +0200
Message-ID: <482F938D.3060405@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYERC0c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 May 2008 22:26:32 -0400
In-Reply-To: <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> And the log difference you can see in
> http://dev.medozas.de/files/.iptables-xtables.txt
> I suggest you take a look.
>   

The committer and author name fixups certainly look nicer, but
things like:

-    Installs libxt_*.so to DEST_IPT_LIBIDR and link libip[6]t_*.so to it.
+    Install libxt_*.so to DEST_IPT_LIBIDR and link libip[6]t_*.so to it

are not good because they make it harder to find discussions that
happend before a patch was committed.


