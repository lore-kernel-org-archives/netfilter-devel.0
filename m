From: Tony Clayton <tony-netfilter@clayton.ca>
Subject: Re: SNAT & default route
Date: Mon, 23 Jun 2003 20:40:08 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624004008.GW32443@gambit.enfusion-group.com>
References: <E19UU5v-0004Ln-00@raggi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Wilson <chris@netservers.co.uk>,
  netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Luca Raggi <llr@raggi.org>
Content-Disposition: inline
In-Reply-To: <E19UU5v-0004Ln-00@raggi.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 23, 2003 at 09:23:08AM -0700, Luca Raggi <llr@raggi.org> wrote:

> ...
> iptables -t nat -A PREROUTING -j CONNMARK --save-mark
> ...
> iptables -t nat -A POSTROUTING -m mark --mark 0x11 -j SNAT --to-source 
> $IP1
> iptables -t nat -A POSTROUTING -m mark --mark 0x12 -j SNAT --to-source 
> $IP2
> iptables -t nat -A POSTROUTING -m mark --mark 0x13 -j SNAT --to-source 
> $IP3
> ...
> # ...commands to replicate all the routes in the three tables omitted...
> ip route add default via $GW1 table t1
> ip route add default via $GW2 table t2
> ip route add default via $GW3 table t3

Hi Luca,

I think what you want is:

  ip route add default via $GW1 src $IP1 table t1
  ip route add default via $GW2 src $IP2 table t2
  ip route add default via $GW3 src $IP3 table t3

and skip the SNAT altogether.  

Good luck

Tony
