From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: force null nat binding on insert
Date: Fri, 14 Feb 2014 17:57:55 +0100
Message-ID: <20140214165755.GA6414@localhost>
References: <1391978109-26507-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33411 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaBNQ6A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:58:00 -0500
Content-Disposition: inline
In-Reply-To: <1391978109-26507-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sun, Feb 09, 2014 at 09:35:09PM +0100, Florian Westphal wrote:
> Quoting Andrey Vagin:
>   When a conntrack is created  by kernel, it is initialized (sets
>   IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
>   is added in hashes (__nf_conntrack_hash_insert), so one conntract
>   can't be initialized from a few threads concurrently.
> 
>   ctnetlink can add an uninitialized conntrack (w/o
>   IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
>   this conntrack and start initialize it concurrently. It's dangerous,
>   because BUG can be triggered from nf_nat_setup_info.
> 
> Fix this race by always setting up nat, even if no CTA_NAT_ attribute
> was requested before inserting the ct into the hash table.
> 
> In absence of CTA_NAT_ attribute, a null binding is created.
> 
> This alters current behaviour:
> Before this patch, the first packet matching the newly injected
> conntrack would be run through the nat table since nf_nat_initialized()
> returns false.  IOW, this forces ctnetlink users to specify the desired
> nat transformation on ct creation time.

I'm having an oops here using conntrack to add an entry with this
patch applied:

[19074.776878] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[19074.777060] IP: [<ffffffffa08ef440>] __nf_nat_l4proto_find+0x19/0x5c [nf_nat]
[19074.777215] PGD ab68d067 PUD b5977067 PMD 0 
[19074.777318] Oops: 0000 [#1] SMP 
[...]
[19074.780691] CPU: 1 PID: 6210 Comm: conntrack Not tainted 3.13.0+ #89
[...]
[19074.781108] RIP: 0010:[<ffffffffa08ef440>]  [<ffffffffa08ef440>] __nf_nat_l4proto_find+0x19/0x5c [nf_nat]

It can be reproduced with:

conntrack -I -p tcp -s 1.1.1.1 -d 2.2.2.2 --timeout 100 --state ESTABLISHED --sport 10 --dport 20
