From: "David S. Miller" <davem@davemloft.net>
Subject: Re: SACK out of window segments?
Date: Sun, 24 Jul 2005 17:54:25 -0700 (PDT)
Message-ID: <20050724.175425.85383589.davem@davemloft.net>
References: <20050721.010634.92583580.davem@davemloft.net>
	<1121933987.15942.9.camel@nienna.balabit>
	<Pine.LNX.4.58.0507241824420.31208@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, hidden@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.58.0507241824420.31208@blackhole.kfki.hu>
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

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Sun, 24 Jul 2005 18:28:19 +0200 (CEST)

> 15:27:27.315245 IP (tos 0x0, ttl  64, id 35783, offset 0, flags [DF], length: 60)
> 	1.1.1.1.4632 > 2.2.2.2.80: S [tcp sum ok] 72431051:72431051(0)
> 	win 5840 <mss 1460,sackOK,timestamp 2766486 0,nop,wscale 0>
> 15:27:27.322134 IP (tos 0x0, ttl 124, id 22926, offset 0, flags [DF], length: 64)
> 	2.2.2.2.80 > 1.1.1.1.4632: S [tcp sum ok] 2187509889:2187509889(0)
> 	ack 72431052 win 65535 <mss 1460,nop,wscale 0,nop,nop,timestamp 0 0,
> 	nop,nop,sackOK>
> 
> The first two packets of the handshake: both window scaling and SACK are
> enabled. The zero window scale factor at "both" parties looks suspicious.

So do we know if the window scale has been modified?  It would
be nice to see a trace where we have both server and client's
view, in order to know if the window scale has been changed
by some device in the middle.

Really, any analysis at all of the rest of the trace is pretty
much a waste of time without that crucial piece of information.
