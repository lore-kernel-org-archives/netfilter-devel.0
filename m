From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 9 Dec 2004 11:34:16 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20041209085249.GA22714@oknodo.bof.de>
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

On Thu, 9 Dec 2004, Patrick Schaaf wrote:

> > - When the conntrack table is full, we search only in a single hash
> >   bucket. We are in trouble anyway, so let's search harder for
> >   droppable entries: the patch extends the search to at most the third of
> >   all the buckets.
>
> Hmm. It's correct that we are in trouble anyway, but will it help burning
> much more CPU to get out of trouble?

How could we lessen the trouble we are in? By refusing to add the new
connection to the table after failing to find an unreplied connection
in one bucket, or searching more with the price of spinning the CPU a
little further?

> Looking for alternatives, I note that early_drop will only consider
> unreplied connections for reaping. In a normal setup, only a small
> number of connections will be unreplied, AND each connection will
> make at most one transition from unreplied to assured.
>
> This suggest, to me, that we keep unreplied connections on a new,
> additional list. They are put there at the HEAD upon creation,
> they are removed form the list when they make their transition
> to assured. And early_drop becomes a simple, O(1) operation:
> reap the connection which is at the TAIL of this new list.
>
> Of course, it's a tradeoff between burning (lots of) CPU when under
> pressure, vs. two list operations per connection for each and every
> connection.

Plus another struct list_head element in struct ip_conntrack.

But I like it! Hmm, expect some new code soon...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
