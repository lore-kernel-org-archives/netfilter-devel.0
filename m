From: Patrick Schaaf <bof@bof.de>
Subject: Re: a question about ipv4 multicast and NAT
Date: Mon, 25 Aug 2003 13:00:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825110055.GD423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(my reply to the last message from Samuele)

Hello Samuele,

> i'll try to be as clear as possible however tell me if there's 
> something you don't understand my english is not so fluent:

Most of the readers/writers here, are afflicted with that problem.
We'll understand you.

> However they are inside a LAaN, so their request have to be "natted"
> from the linux gw to the outside

Really? Note that I'm not awfully proficient in things multicast,
but it was my impression that the first router in front of MC
clients, would speak IGMP with the clients, and talk to the
network accordingly; thus, I would expect that a proper multicast
router setup on the linux gw, would provide everything you need,
no NAT needed at all.

Did you try going that mroute?

> the same thing should be possible if people from 192.168/24 wants to send
> their video stream to the outside, but in this case things could be a bit
> more complicated because you have to "nat" the outgoing stream and announce.

I imagine this is a _completely_ different scenario. I'd even question
the sanity of an ISP _permitting_ you to do that.

> In this manner, with an isp that is multicast capable people can use multicast
> for conferencing or just for fun .
> 
> Please tell me if something is not clear, or if i haven't answered correctly
> to your question.

I fear that I'm too naive about multicast to be of more help. You have
described your "use case" pretty well, I think - maybe somebody else can
jump in now and enlighten us?

best regards
  Patrick
