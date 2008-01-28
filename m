From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Bug with Fedora's 2.6.23.9-85 kernel (at least) and ESTABLISHED
 and SACK
Date: Mon, 28 Jan 2008 10:53:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801281053100.1185@fbirervta.pbzchgretzou.qr>
References: <479D64B0.10101@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52814 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYA1Jxp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:53:45 -0500
In-Reply-To: <479D64B0.10101@acm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 27 2008 22:14, Zan Lynx wrote:
>
> Please CC me on any replies as I am not subscribed.
>
> I was downloading a new Google Earth when I noticed a LOT of
> max-size dropped packets in my firewall log.  I only allow
> RELATED,ESTABLISHED sessions into my firewall.
>
> tcpdump showed that every time Google sent a packet to satisfy the
> missing data identified by SACK, that packet was rejected.  So it
> must have been missing the ESTABLISHED rule.

You can check the connection state with `conntrack -L`, or in
/proc/net/{ip,nf}_conntrack. What does it read?
