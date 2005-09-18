From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Sun, 18 Sep 2005 13:37:47 +0300
Message-ID: <87vf0y7jb8.fsf@aka.i.naked.iki.fi>
References: <4326FF69.9060004@trash.net> <871x3p875j.fsf@aka.i.naked.iki.fi>
	<432C58F5.8030306@trash.net>
	<20050918.002730.74976897.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050918.002730.74976897.davem@davemloft.net> (David S. Miller's
	message of "Sun, 18 Sep 2005 00:27:30 -0700 (PDT)")
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

David S. Miller wrote:
> Nuutti is it possible to test without the pcap packet tap active
> on the interface?  That would help us enormously in narrowing down
> where the problem might be.  If we can definitely put the blame
> on the pcap being active, we can probably fix this very fast.

I'm afraid not. We haven't been able to reproduce the problem in any
other case except the full setup and that depends on having pcap
active. I'll find out on monday if there is some trick that could be
used to run the whole thing without pcap.

I did a separate test earlier, which had a dummy program saying
NF_ACCEPT to every QUEUE packet and TCP streams going both ways with
pcap active - but at that time, I did not realize to test the TCP
streams closing and opening, so there were no TCP FINs transmitted.

Our next step in testing is to modify the application handling the
QUEUE packets to detect TCP FIN,ACK packets and intentionally sleep
for a bit before accepting them - with that we can see if it crashes a
lot sooner that way and pinpoint the problem at something bad
happening while the packets sit in the QUEUE.

If that doesn't help then I'm a bit dubious on managing to reproduce
this without the full setup. Since it requires SMP to crash and may
take 8 hours to crash, this sounds like a nasty timing issue and it
may not be too easy to get similar conditions.

-- Naked
