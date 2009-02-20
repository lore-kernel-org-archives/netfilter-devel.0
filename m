From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables return code 256
Date: Fri, 20 Feb 2009 21:35:48 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902202134350.11155@fbirervta.pbzchgretzou.qr>
References: <gnn43d$647$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ralf <rm@amitrader.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZBTUft (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:35:49 -0500
In-Reply-To: <gnn43d$647$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-20 21:33, Ralf wrote:

> Sometimes an insert operation (-I) fails and iptables returns 256.
> Under which circumstances can iptables give a return code 256 ?

Never should this happen, because the lower 8 bits of 256 that
make up the exist status are 0 actually.
Or where do you see 256?
