From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] ipvs: add static and read_mostly attributes
Date: Tue, 16 Nov 2010 07:03:30 +0900
Message-ID: <20101115220330.GD10582@verge.net.au>
References: <1289842732.2607.111.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46128 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab0KOWDd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:03:33 -0500
Content-Disposition: inline
In-Reply-To: <1289842732.2607.111.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 15, 2010 at 06:38:52PM +0100, Eric Dumazet wrote:
> ip_vs_conn_tab_bits & ip_vs_conn_tab_mask are static to
> ipvs/ip_vs_conn.c
> 
> ip_vs_conn_tab_size, ip_vs_conn_tab_mask, ip_vs_conn_tab [the pointer],
> ip_vs_conn_rnd are mostly read.

Thanks, I'll take this through the lvs-test-2.6 tree
(which probably wants a new name).

