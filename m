From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bridge: fix rcu dereference outside of rcu_read_lock
Date: Wed, 15 Aug 2012 15:10:25 -0700 (PDT)
Message-ID: <20120815.151025.1185439989487730645.davem@davemloft.net>
References: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
	<1344931732-1858-1-git-send-email-yefremov.denis@gmail.com>
	<20120814081933.30f3e868@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yefremov.denis@gmail.com, pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	ldv-project@ispras.ru
To: shemminger@vyatta.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2HOWK2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:10:28 -0400
In-Reply-To: <20120814081933.30f3e868@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 14 Aug 2012 08:19:33 -0700

> Alternative solution for problem found by Linux Driver Verification
> project (linuxtesting.org).
> 
> As it noted in the comment before the br_handle_frame_finish
> function, this function should be called under rcu_read_lock.
> 
> The problem callgraph:
> br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
>  -> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference
> 
> And in this case there is no read-lock section.
> 
> Reported-by: Denis Efremov <yefremov.denis@gmail.com>
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, thanks Stephen.

Please CC: this to netdev next time.  It's in a grey area whether I or
the netfilter folks should apply this one, and here I'm deciding to
take care of it.

