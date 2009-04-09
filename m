From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Multiple IPs on iptables/ip6tables command line
Date: Thu, 9 Apr 2009 20:53:23 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904092053110.26400@fbirervta.pbzchgretzou.qr>
References: <49DE2F54.1040703@zeus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Michael Granzow <mgranzow@zeus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52861 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZDISx0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:53:26 -0400
In-Reply-To: <49DE2F54.1040703@zeus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-04-09 19:24, Michael Granzow wrote:

>It seems iptables (and ip6tables) can only process one IP address at a
>time which makes blocking many IP addresses a rather slow process.
>
>The following patch seems to work for me and I'd be grateful for your
>feedback.

patch: **** malformed patch at line 42: *xtables_numeric_to_ipaddr(const char
*);

