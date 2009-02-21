From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: install nf_conntrack_tuple.h header
Date: Sat, 21 Feb 2009 04:24:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210420400.31975@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0902210409170.28533@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38997 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZBUDYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:24:08 -0500
In-Reply-To: <alpine.LSU.2.00.0902210409170.28533@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-21 04:10, Jan Engelhardt wrote:
>
>While trying to resynchronize headers from the kernel->iptables,
>I stumbled upon a missing file...

Meh, nf_nat.h is not in include/linux/netfilter/, but
include/net/netfilter/, which means `make headers_install` will
usually not install it. Well, at least it was not me who added
nf_nat.h to the iptables tree ;-)
Disregard the patch.
