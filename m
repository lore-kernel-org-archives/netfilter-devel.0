From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Mon, 19 Sep 2005 16:34:08 +0300
Message-ID: <87fys16v1r.fsf@aka.i.naked.iki.fi>
References: <4326FF69.9060004@trash.net> <871x3p875j.fsf@aka.i.naked.iki.fi>
	<432C58F5.8030306@trash.net>
	<20050918.002730.74976897.davem@davemloft.net>
	<87vf0y7jb8.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <87vf0y7jb8.fsf@aka.i.naked.iki.fi> (Nuutti Kotivuori's message
	of "Sun, 18 Sep 2005 13:37:47 +0300")
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

Nuutti Kotivuori wrote:
> David S. Miller wrote:
>> Nuutti is it possible to test without the pcap packet tap active
>> on the interface?  That would help us enormously in narrowing down
>> where the problem might be.  If we can definitely put the blame
>> on the pcap being active, we can probably fix this very fast.
>
> I'm afraid not. We haven't been able to reproduce the problem in any
> other case except the full setup and that depends on having pcap
> active. I'll find out on monday if there is some trick that could be
> used to run the whole thing without pcap.

Disabling all the uses of packet sockets in the code was deemed an
overwhelming job, but through certain modifications we were able to
run the system such that it did not need the packet socket capturing
at all.

After that I made a patch that disabled all the calls to dev_add_pack
and dev_remove_pack from af_packet.c and verified that with this
setup, tcpdump indeed did not receive any packets.

However, this did not fix the problem. Since no backtrace was
available in this current setup, I could not verify that packet_rcv
was never called, but I am pretty certain that it wasn't.

So I think it is safe to rule out the hypothesis taht the packet
socket might have something to do with it.

-- Naked
