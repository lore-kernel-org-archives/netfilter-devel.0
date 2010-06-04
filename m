From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: vmalloc_node cleanup
Date: Fri, 04 Jun 2010 13:32:55 +0200
Message-ID: <4C08E467.4010403@trash.net>
References: <1275454950.2638.121.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0FDLc6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:32:58 -0400
In-Reply-To: <1275454950.2638.121.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Using vmalloc_node(size, numa_node_id()) for temporary storage is not
> needed. vmalloc(size) is more respectful of user NUMA policy.

Applied, thanks Eric.
