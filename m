From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: SNAT & default route
Date: Mon, 23 Jun 2003 15:38:28 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0306231536100.3936-100000@localhost>
References: <E19UKfY-00043o-00@raggi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Luca Raggi <llr@raggi.org>
In-Reply-To: <E19UKfY-00043o-00@raggi.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Luca,

> - Using MARK, CONNMARK, and fwmark to select an iproute2 table with the
>   right default gateway. While the marks are set correctly (for both 
> packet
>   N=1 and packets N>=2), in the end the routing decision is apparently
>   discarded, and the main default is used anyways (for all values of N.)
>   This only happens for forwarded/SNAT'ed packets, however. Locally
>   originating packets and non-SNAT'ed forwarded packets get routed
>   correctly (via "ip rule from"'s that point to the same tables that the
>   higher-priority "ip rule fwmark"'s point to.)

I haven't tried this with CONNMARK, but I know that iproute+MARK works 
because I've used it. Can you post examples of what rules you are using?

> - Using the ROUTE target in various places to try to force the correct
>   behavior. Unfortunately, trying to ROUTE before SNAT'ing bypasses the
>   SNAT'ing, and ROUTE'ing after the SNAT'ing is apparently impossible,
>   since there's no chain after the nat/POSTROUTING chain in which to place
>   the ROUTE rule.

How about placing your ROUTE rule in mangle/FORWARD? There may be issues 
with the nat table only seeing the first packet of each connection.

If you put the ROUTE rule into mangle/POSTROUTING and the SNAT rule into 
nat/POSTROUTING, does it prevent the SNAT from being read?

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
