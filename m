From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Possible iptables 4.4.11 issues
Date: Sun, 29 May 2011 16:48:31 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
References: <4DE2593E.7000208@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Steven Jan Springl <steven@springl.ukfsn.org>
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33357 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab1E2Osd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 10:48:33 -0400
In-Reply-To: <4DE2593E.7000208@shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2011-05-29 16:33, Tom Eastep wrote:
>After upgrading iptables to 1.4.11 the following iptables-restore error
>is produced:
>
>iptables-restore v1.4.11: owner: option "--uid-owner" cannot be inverted.

Bug, fix will be submitted.


>-A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
>dst --and-mask -1 --or-mask -64 --shift 0
>After upgrading to iptables 1.4.11 the following iptables-restore error is
>produced:
>
>iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1"

This is intentional. Bitwise operations work best when fed unsigned numbers
only.
