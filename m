From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Mon, 13 Dec 2004 22:52:44 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412132055520.19900@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
	<1102772053.12078.40.camel@tux.rsn.bth.se>
	<Pine.LNX.4.58.0412111740420.16780@blackhole.kfki.hu>
	<Pine.LNX.4.61.0412121225240.30324@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>, Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0412121225240.30324@filer.marasystems.com>
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

On Sun, 12 Dec 2004, Henrik Nordstrom wrote:

> On Sat, 11 Dec 2004, Jozsef Kadlecsik wrote:
>
> > It's already a little bit messy. I strongly believe, we must revise
> > reference counting in order to make locking more straightforward (and to
> > be able to introduce say per bucket locking at all). The
> > conntrack_arefcount patch tries to step ahead in that direction.
>
> The patch adds yet another entity needing locking: The list of unassured
> connections. This list requires two write updates per new connection
> (append, delete).

I just wanted to note that fine grained locking needs some preparation.

> With it being a linked list fine grained locking becomes a bit hard, and
> to have FIFO semantics there is not many other choices. But fortunately
> the operations needing this list locked is very short in time so it should
> be fine with a global lock on the unassured list, in addition to the
> (finegrained) conntrack locking, provided the unassured lock is aquired
> last (atomic list insert, delete operations).

With a little tweaking we could create a fast path for the new conntrack
entries:  in __ip_conntrack_confirm do not add them to the unassured_list
till we have, say, more than 5% percent of the conntrack entries free.
Of course when assuring/deleting a conntrack, we should still lock, check
and delete, unlock, but that is not the critical path.

> Note: RCU does not help us here.

Yes, no way to use RCU.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
