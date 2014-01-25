From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sat, 25 Jan 2014 13:55:52 +0000
Message-ID: <20140125135552.GA31554@macbook.localnet>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47910 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaAYNzz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 08:55:55 -0500
Content-Disposition: inline
In-Reply-To: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> We may lost race if we flush the rule-set (which happens asynchronously
> via call_rcu) and we try to remove the table (that userspace assumes
> to be empty).
> 
> Fix this by recovering synchronous rule and chain deletion. This was
> introduced time ago before we had no batch support, and synchronous
> rule deletion performance was not good. Now that we have the batch
> support, we can just postpone the purge of old rule in a second step
> in the commit phase. All object deletions are synchronous after this
> patch.
> 
> As a side effect, we save memory as we don't need rcu_head per rule
> anymore.
> 
> Cc: Patrick McHardy <kaber@trash.net>
> Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> We still have a bug somewhere else. When creating 10000 rules like:
> tcp dport { 22, 23 }, I can see more than 10000 sets.
> 
> # ./nft-set-get ip | wc -l
> 10016
> 
> It seems set 511 is not being used. See below:
> 
> # ./nft-rule-get
> ip filter output 513 512
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ lookup reg 1 set set510 ]
>   [ counter pkts 0 bytes 0 ]
> 
> ip filter output 514 513
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ lookup reg 1 set set512 ]
>   [ counter pkts 0 bytes 0 ]
> 
> It seems to happen every 512 sets are added. Still investigating, so
> this needs a second follow up patch to resolve what Arturo is reporting.

Yeah, we seem to have a couple of bugs in nf_tables_set_alloc_name().
I'll fix them up and will then have a look at this patch.
