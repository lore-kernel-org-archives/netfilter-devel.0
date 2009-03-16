From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: increase drop stats if sequence
 adjustment fails
Date: Mon, 16 Mar 2009 15:19:29 +0100
Message-ID: <49BE5FF1.7070705@trash.net>
References: <20090303233657.7390.5796.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbZCPOTc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:19:32 -0400
In-Reply-To: <20090303233657.7390.5796.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch increases the statistics of packets drop if the sequence
> adjustment fails in ipv4_confirm().

Applied, thanks.
