From: Michael Gundlach <gundlach@cs.uga.edu>
Subject: Re: Urgent question: changing src|dst IP w/ ipq fails
Date: Tue, 18 Feb 2003 17:53:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218175359.C25778@cs.uga.edu>
References: <20030218162320.A25778@cs.uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030218162320.A25778@cs.uga.edu>; from gundlach@cs.uga.edu on Tue, Feb 18, 2003 at 04:23:20PM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again everyone,

After mailing the list I found something on the netfilter archives saying
that the FORWARD chain is traversed after kernel routing decisions have
been made.  Is this the (unfortunate) answer I was looking for - that if I
get a packet on the FORWARD chain I can't change its destination, or
routing fails and the packet is dropped?

Thanks
Michael

On Tue Feb 18, 2003 at 04:23PM, Michael Gundlach wrote:

> I have a machine A sending packets to machine C, and machine B is a linux
> bridge running ipq between them on the network.  B is catching all packets
> between A and C, looking at them, and reinjecting them.  This works just
> fine, and A and C can talk happily together without knowing that the bridge
> B is between them.
> 
> Now I wish to modify the source or destination addresses of these
> packets before reinjecting them.  Modifying the source or destination
> *port* and reinjecting the packet works fine - the destination computer
> (running tcpdump) sees a packet from the source, using the new source or
> destination port that ipq put in.
> 
> However, modifying the source or destination *IP* does not work.  When IPQ
> changes a A->D packet to be A->C, C never gets the packet.  When IPQ changes
> a A->C packet to be D->C, C will *eventually* (after 20+ seconds) get a
> packet claiming to come from D.  Running tcpdump on the bridge B, I see a
> TCP SYN packet come in from A->C, and 20 seconds later or so a TCP SYN
> packet D->C (the reinjected packet); but only, say, 2 out of 3 of the A->C
> packets get successfully retransmitted as D->C.
> 
> Any idea what I am doing wrong?  I am recalculating IP and TCP checksums OK,
> I know that.  A colleague thinks perhaps I have to set up a new route in
> the kernel-level code when I modify the destination IP, but I don't think
> so - since ipq is a user-level interface.  Also, that wouldn't solve the
> source-IP-modification problem.
> 
> I am using a version of netfilter 1.6a that is patched to work with a
> bridging kernel.
> 
> Thanks in advance - and *please* post back soon :)  Even if it's past the
> morning of Feb 19th, I still need to figure this out.
> Michael Gundlach
> 
