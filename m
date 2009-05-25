From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: add missing DCCP protocol changes
 in	event cache
Date: Mon, 25 May 2009 17:30:54 +0200
Message-ID: <4A1AB9AE.3020305@trash.net>
References: <20090509184316.7636.12044.stgit@Decadence> <20090509184603.7636.66528.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61377 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZEYPay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2009 11:30:54 -0400
In-Reply-To: <20090509184603.7636.66528.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the missing protocol state-change event reporting
> for DCCP.
> 
> $ sudo conntrack -E
>     [NEW] dccp     33 240 src=192.168.0.2 dst=192.168.1.2 sport=57040 dport=5001 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=5001 dport=57040
> 
> With this patch:
> 
> $ sudo conntrack -E
>     [NEW] dccp     33 240 REQUEST src=192.168.0.2 dst=192.168.1.2 sport=57040 dport=5001 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=5001 dport=57040
>

Applied, thanks Pablo.

