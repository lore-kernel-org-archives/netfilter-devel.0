From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCPMSS target for IPv6
Date: Wed, 17 Dec 2003 20:36:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312172005030.18802-100000@filer.marasystems.com>
References: <20031215210705.GA2326@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nicolas George <nicolas.george@ens.fr>
In-Reply-To: <20031215210705.GA2326@clipper.ens.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Dec 2003, Nicolas George wrote:

> You are right, the problem is adressed, and it should work. Alas, there
> is difference between what is written in RFC and what programmers really
> do.

And generally those differences makes failures and interoperability
issues.

> Unfortunately, I do not control any part of the tunnel itself (it is a
> 6to4 tunnel), so I can not track the exact problem, and even less
> correct it. The only solution I see to avoid freezed TCP connections is
> to advertise a small enough MSS. I can do that by globally lowering my
> MTU, but this is a quite ugly solution. Being able to do that on a
> per-IP basis would be great.

MTU and MSS is different things. MTU is here and now for sending this IP
packet on this path, MSS is end-to-end telling the other end how large TCP
segments you can accept (after defrag).  There is no problem in setting up
routing with a different MTU depending the desitnation to work around
broken equipment where PMTU-discovery does not work, except that the IPv6
routing implementation in Linux maybe is a little short when it comes to
advanced routing..

By modifying the MSS below the assumed Path-MTU (minus headers) you avoid
the Path-MTU discovery problem for return traffic as there will not be any
packets much larget than the MSS, and if done in both directions it can
work around MTU problems in both directions for TCP traffic.

But is does not solve the underlying MTU problem, and you may still risk
running into MTU issues especially if there is non-TCP traffic involved as 
MSS only applies to TCP, not UDP/AH/ESP/Whatever.

> My point is that we do not need TCPMSS less for IPv6 than for IPv4
> (except that IPv6 itself is seldom used): the goal of such a target is
> to workaround bogus infrastructures ("criminally braindead ISPs"), and
> there seems to exist as much of those for IPv6 as for IPv4 (and anyway
> tunnels give us the worst of both worlds).

Partly agreed, but I disagree with the use of MSS to work around Path-MTU
problems to begin with. Modifying MSS has other applications which may be
useful howenver (even if I do not remember any right now).

PMTU issues (not PMTU discovery as such) is relatively rare unless there
is tunnels involved. Any tunneling equipment not properly (automatically
or manually) handling PMTU at the endpoints is broken and needs to be
fixed now. There may be a slight delay in PMTU-discovery for tunnels while
the tunnel as such adjusts its MTU but this should not be larger than 2
packets, one on for the PMTUD of the tunnel as such, another for the PMTUD
of the "client" traffic.

If the tunnieling equipment does not handle PMTU of the tunnel then you 
better make sure the tunnel is only set up over a path where the PMTU is 
priorly known allowing the MTU to be set correctly for the tunnel.

Regards
Henrik
