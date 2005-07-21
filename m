From: Patrick McHardy <kaber@trash.net>
Subject: Re: traffic shaping and fixed per-packet overhead
Date: Thu, 21 Jul 2005 20:28:28 +0200
Message-ID: <42DFE94C.4050307@trash.net>
References: <pan.2005.07.21.07.17.08.357408@smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Urlichs <smurf@smurf.noris.de>
In-Reply-To: <pan.2005.07.21.07.17.08.357408@smurf.noris.de>
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

Matthias Urlichs schrieb:
> Hi,
> 
> I have an IPIP tunnel through a DSL line (PPPoE) which I need to
> traffic-shape / flow control. Unfortunately, the tunnel has a fixed
> per-packet overhead, which means that small packets overrun the
> bandwidth allowed for the tunnel and get dropped, while (if I set the
> allowed bandwidth to too-small values) the wire will be idle when
> I send large packets.
> 
> (I'm using HTB.)
> 
> I can think of a couple of solutions ...
> - Use bit-banging in the outer filter instead of nice rules on the tunnel.
>   (OK, that's a dumb idea from a useability POV.)
> - Extend the HTB code to allow specifying a per-packet overhead.
> - Hack the kernel to propagate a packet's netfilter MARK.

Totally unrelated to netfilter-devel, but:

# tc qdisc add htb help
...
  mpu      minimum packet size used in rate computations
  overhead per-packet size overhead used in rate computations
