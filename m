From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 9 Dec 2004 09:52:50 +0100
Message-ID: <20041209085249.GA22714@oknodo.bof.de>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

> The included patch addresses the following issues:
> 
> - When the conntrack table is full, we search only in a single hash
>   bucket. We are in trouble anyway, so let's search harder for
>   droppable entries: the patch extends the search to at most the third of
>   all the buckets.

Hmm. It's correct that we are in trouble anyway, but will it help burning
much more CPU to get out of trouble?

Looking for alternatives, I note that early_drop will only consider
unreplied connections for reaping. In a normal setup, only a small
number of connections will be unreplied, AND each connection will
make at most one transition from unreplied to assured.

This suggest, to me, that we keep unreplied connections on a new,
additional list. They are put there at the HEAD upon creation,
they are removed form the list when they make their transition
to assured. And early_drop becomes a simple, O(1) operation:
reap the connection which is at the TAIL of this new list.

Of course, it's a tradeoff between burning (lots of) CPU when under
pressure, vs. two list operations per connection for each and every
connection.

best regards
  Patrick
