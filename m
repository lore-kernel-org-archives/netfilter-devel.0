From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] iptables: Fix chain rename bug in libiptc.
Date: Mon, 23 Mar 2009 14:26:19 +0100
Message-ID: <49C78DFB.4090306@trash.net>
References: <20090323125514.959.87191.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@comx.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZCWN01 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:26:27 -0400
In-Reply-To: <20090323125514.959.87191.stgit@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> Chain renaming (TC_RENAME_CHAIN) can result in an unsorted
> chain list.  That breaks the requirement of the binary search
> done in iptcc_bsearch_chain_index().

Applied, thanks.
