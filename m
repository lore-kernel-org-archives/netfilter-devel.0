From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Tue, 11 Oct 2005 16:52:31 +0100
Message-ID: <434BDFBF.4090802@ufomechanic.net>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<20051007034224.GB5953@rama> <434B8202.9020703@ufomechanic.net>
	<20051011144157.GF4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011144157.GF4756@rama.de.gnumonks.org>
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

Harald Welte wrote:

>
>it's fairly common practise to use some random value in a hash
>function to not expose the hash table to an attack on it.  It's what all
>over the networking code is used for many hash tables.
>
>I don't see how this ever could produce an error.  The hash function is
>still deterministic, since the random value is static as long as the
>hash table exists.
>
>  
>
Yes you are right, this makes sense.

I recall some recent(ish) improvements to the perl hash code to avoid
memory explosions on deviously crafted input, perhaps the solution was a
random seed, or perhaps it was better re-hashing which is understandably
less deterministic and not so suited for networking code.

Thanks for the enlightenment

Sam
