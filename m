From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter: nf_conntrack: there maybe a bug in
 __nf_conntrack_confirm, when it race against get_next_corpse
Date: Tue, 28 Oct 2014 10:46:12 +0100
Message-ID: <20141028094612.GA14392@breakpoint.cc>
References: <02ef01cff25f$29887f60$7c997e20$@gmail.com>
 <02f201cff260$8622e610$9268b230$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	'Netfilter Developer Mailing List'
	<netfilter-devel@vger.kernel.org>,
	'Pablo Neira Ayuso' <pablo@netfilter.org>,
	'Patrick McHardy' <kaber@trash.net>, kadlec@blackhole.kfki.hu,
	davem@davemloft.net, 'Changli Gao' <xiaosuo@gmail.com>,
	'Jesper Dangaard Brouer' <brouer@redhat.com>,
	'Andrey Vagin' <avagin@openvz.org>
To: billbonaparte <programme110@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <02f201cff260$8622e610$9268b230$@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

billbonaparte <programme110@gmail.com> wrote:
> 	In function __nf_conntrack_confirm, we check the conntrack if it was
> alreay dead, before insert it into hash-table. 
> 	we do this because if we insert an already 'dead' hash,  it will
> block further use of that particular connection.
> 	but we don't do that right.

Correct.  This is broken since the central spin lock removal, since
nf_conntrack_lock no longer protects both get_next_corpse and
conntrack_confirm.

Please send a patch, moving dying check after removal of conntrack from
the percpu list, and add

Fixes: 93bb0ceb75be2 (netfilter: conntrack: remove central spinlock nf_conntrack_lock)

tag to patch.

> 	The above case reveal two problems:
> 	1. we may insert a dead conntrack to hash-table, it will block
> further use of that particular connection.

Yes.

> 	2. operation on ct->status should be atomic, because it race aginst
> get_next_corpse.

Alternatively we could also get rid of the unconfirmed list handling in
get_next_corpse, it looks to me as if its simply not worth the trouble
to also caring about unconfirmed lists.
