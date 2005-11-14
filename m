From: Toby DiPasquale <codeslinger@gmail.com>
Subject: Re: Need help combining packets in netfilter driver...
Date: Mon, 14 Nov 2005 09:14:21 -0500
Message-ID: <876ef97a0511140614s6bc3d689k2de207fd1b4f0605@mail.gmail.com>
References: <4378323F.4010001@bangkok-peakoil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Dickerson <tomdi@bangkok-peakoil.com>
In-Reply-To: <4378323F.4010001@bangkok-peakoil.com>
Content-Disposition: inline
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

On 11/14/05, Tom Dickerson <tomdi@bangkok-peakoil.com> wrote:
> My first plan was to hook in at POSTROUTING after all routing had been
> performed. In that hook I would simply compress and buffer the data in
> private storage, returning DROP for all the packets until I got a
> complete buffer. If the buffer was complete, I'd replace the skb with my
> own skb consisting of the aggregate packets I had stored and return ACCEP=
T.

You may want to implement a custom queueing discipline to get this
done. Qdiscs already are intimate with timers in the manner that you
need and it would be simple to aggregate the packets as they arrive,
simply updating header information as each new packet arrived. They
could then be fired out when the qdisc calls for packets when the
timer expires.

For information on qdisc programming, first read http://lartc.org to
get an idea of how they are used. Then check out the source of
net/sched/sch_tbf.c and net/sched/sch_sfq.c in you Linux kernel
sources. If you need the qdisc to be classful (you'll know what that
entails after reading LARTC above), you should look at
net/sched/sch_htb.c.

> Also, on the receiving side, I need to reconstruct the original packet
> stream. I was thinking that in the PREROUTING hook I could simply
> decompress the packet back into the original packet stream. But this
> means I have to inject N-1 new packets directly into the netfilter
> stream. Can this be done from the PREROUTING hook?

This could be done with an ingress qdisc. Exploding packets in
iptables has been, how shall we say... problematic, for me at least.
You should have less of an issue with this by creating a custom
ingress qdisc. Check out the code in net/sched/sch_ingress.c for an
idea of how to implement an ingress qdisc. (currently in Linux, there
is only one)

> Note that the Linux box is simply acting as a router for these packets.
> The packets are generated on remote servers and are destined for remote
> servers. There are no userspace programs involved in the packet
> transactions.

Yeah, this really indicates a custom qdisc to me. That would seem to
me to be the most workable and elegant solution to your problem.
Alternatively, you could attempt to hack the wireless driver and
aggregate+compress the packets at that point, but the qdisc is more
elegant IMO.

As far as resources on the Linux qdisc API, there aren't many. I
couldn't find the one that I was thinking of, but here are some that
have good information:

http://qos.ittc.ku.edu/howto.pdf
http://www.cs.odu.edu/%7Egmanepal/documents/qos.pdf

The paper is quite old, but mostly still correct.

As I was googling around to find that, however, I found this, which
may be of some use to you, as well, as it speaks more directly to your
problem area:

http://www.cs.umu.se/education/examina/Rapporter/JohanCimen.pdf

Good luck!

--
Toby DiPasquale
0x636f6465736c696e67657240676d61696c2e636f6d
