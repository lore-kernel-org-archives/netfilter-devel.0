From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: port-based filtering of ESP packets with in-kernel IPsec?
Date: Wed, 30 Jul 2003 11:34:43 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0307301124150.22684-100000@localhost>
References: <1059540296.16545.305.camel@k7.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1059540296.16545.305.camel@k7.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Rick,

> Since ESP packets that reach the mangle INPUT chain are destined for a
> local process, why not unencapsulate them just before that point?  It
> might still be nice to have an indication that this was once an ESP
> packet for filtering, but that could be done by setting a mark in the
> mangle PREROUTING chain.

The ESP itself will presumably be for a security association (SA) which
terminates on the machine, but it could easily be for some tunnel, in
which case the unencrypted packet should be sent through FORWARD instead 
of INPUT.

Logically, it makes sense to me that the packet should pass through the 
whole of Netfilter _again_ after it's been decapsulated, similarly to what 
now happens with FreeS/WAN (but presumably without an ipsec0 interface 
being involved). Or, maybe it should be decapsulated before routing (and 
hence visible unencrypted in FORWARD, INPUT and OUTPUT).

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
