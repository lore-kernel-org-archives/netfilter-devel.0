From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] iptables: Fix chain rename bug in libiptc.
Date: Mon, 23 Mar 2009 14:55:25 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903231455150.18314@fbirervta.pbzchgretzou.qr>
References: <20090323125514.959.87191.stgit@localhost.localdomain> <49C78DFB.4090306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZCWNz2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:55:28 -0400
In-Reply-To: <49C78DFB.4090306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-03-23 14:26, Patrick McHardy wrote:

> Jesper Dangaard Brouer wrote:
>> Chain renaming (TC_RENAME_CHAIN) can result in an unsorted
>> chain list.  That breaks the requirement of the binary search
>> done in iptcc_bsearch_chain_index().
>
> Applied, thanks.

I take it now we can release..
