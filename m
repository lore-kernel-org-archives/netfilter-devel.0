From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 19:08:36 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030530072818.E2AAB2C053@lists.samba.org>
References: <200305290113.58552.prez@srealm.net.au>
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
In-reply-to: Your message of "Thu, 29 May 2003 01:13:47 -0400."
             <200305290113.58552.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <200305290113.58552.prez@srealm.net.au> you write:
> We have a system that acts as a router, however any new inbound connection for
> any machine behind this router is re-directed to a specific port on the local
> machine, where an application responds as if it were the system behind the
> router.  These systems experience some very high volumes of traffic

Sounds a lot like something is happening to the FIN or RST packets: as
soon as conntrack sees a FIN or RST, it'll leave ESTABLISHED and
timeout fairly quickly.

Now, there are several simple things you can do here, as well as
dropping the ESTABLISHED timeout:

1) Try 2.4.21-rc5.  The hashing algorithm was markedly improved, which
   you could well be hitting.

2) You set the conntrack_max to 524280, but on a 1GB machine you'll
   only have about 8192 hash chains, making each chain 64 long.  Up
   the hashsize module parameter to around 100000 (or edit the kernel
   source if builtin, sorry).

There are certainly more intrusive measures we can investigate, too.

> We have multiple systems performing this task (essentially for load balancing
> and to remove a single point of faulure).

Um, how are you load balancing?  Remember, if the connection tracking
code doesn't see all the packets for a connection, it can't work.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
