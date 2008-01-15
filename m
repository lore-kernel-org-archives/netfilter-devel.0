From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Supress some sparse warnings
Date: Tue, 15 Jan 2008 16:45:41 +0100
Message-ID: <478CD525.3000000@trash.net>
References: <20080115124046.1c10dfeb.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42977 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYAOPp6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:45:58 -0500
In-Reply-To: <20080115124046.1c10dfeb.dada1@cosmosbay.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Hi Patrick
> 
> Please find some sparse cleanups, against net-2.6.25
> 
> Thank you
> 
> [NETFILTER]: Supress some sparse warnings
> 
>   CHECK   net/netfilter/nf_conntrack_expect.c
> net/netfilter/nf_conntrack_expect.c:429:13: warning: context imbalance in 'exp_seq_start' - wrong count at exit
> net/netfilter/nf_conntrack_expect.c:441:13: warning: context imbalance in 'exp_seq_stop' - unexpected unlock
>   CHECK   net/netfilter/nf_log.c
> net/netfilter/nf_log.c:105:13: warning: context imbalance in 'seq_start' - wrong count at exit
> net/netfilter/nf_log.c:125:13: warning: context imbalance in 'seq_stop' - unexpected unlock
>   CHECK   net/netfilter/nfnetlink_queue.c
> net/netfilter/nfnetlink_queue.c:363:7: warning: symbol 'size' shadows an earlier one
> net/netfilter/nfnetlink_queue.c:217:9: originally declared here
> net/netfilter/nfnetlink_queue.c:847:13: warning: context imbalance in 'seq_start' - wrong count at exit
> net/netfilter/nfnetlink_queue.c:859:13: warning: context imbalance in 'seq_stop' - unexpected unlock

Applied, thanks Eric.

