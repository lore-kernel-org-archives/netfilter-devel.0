From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 3/9] tproxy: added udp6_lib_lookup function
Date: Thu, 21 Oct 2010 16:06:24 +0200
Message-ID: <4CC048E0.5040401@trash.net>
References: <20101021104709.5192.31249.stgit@este.odu> <20101021104709.5192.57640.stgit@este.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	David Miller <davem@davemloft.net>
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab0JUOG0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:06:26 -0400
In-Reply-To: <20101021104709.5192.57640.stgit@este.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.10.2010 12:47, schrieb KOVACS Krisztian:
> Just like with IPv4, we need access to the UDP hash table to look up local
> sockets, but instead of exporting the global udp_table, export a lookup
> function.

Applied, thanks.
