From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] Namespacify various ip sysctl knobs
Date: Tue, 16 Feb 2016 20:43:28 -0500 (EST)
Message-ID: <20160216.204328.1217913168570304116.davem@davemloft.net>
References: <1455530583-23053-1-git-send-email-kernel@kyup.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
	pabeni@redhat.com, jmorris@namei.org
To: kernel@kyup.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42741 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799AbcBQBnb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 20:43:31 -0500
In-Reply-To: <1455530583-23053-1-git-send-email-kernel@kyup.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Nikolay Borisov <kernel@kyup.com>
Date: Mon, 15 Feb 2016 12:02:57 +0200

> This series continues namespacifying more net related knobs.
> The focus here is on ip options. Patches 1,3,4,5 namespacify
> the respective sysctl knobs. Patch 2 moves some igmp code to the 
> correct file (and function) and also adds some #ifdef guards to 
> silence compilation warnings. 
> 
> Finally, patch 5 exposes the ip fragmentation related sysctls 
> since all of the knobs are namespaced.

Series applied, but I found Arnd's fix for the unused local variable
problems much nicer.  I wish you had fixed it that way.
