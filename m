From: Karlis Peisenieks <karlis@mt.lv>
Subject: Re: [netfilter-core] recent in_range fix uncovered another bug?
Date: Thu, 11 Sep 2003 10:09:56 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911070956.GA950@mt.lv>
References: <20030910110555.GA30240@mt.lv> <20030911061644.B23BC2C0A7@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030911061644.B23BC2C0A7@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 11, 2003 at 03:45:53PM +1000, Rusty Russell wrote:
> In message <20030910110555.GA30240@mt.lv> you write:
> > Hello!
> > 
> > I came across "lockup" in conntrack code using 2.4 kernel with bridge 
> > netfilter (which is standart in 2.6 kernel) patch applied. Lockup can be 
> > reproduced by pinging some host over bridge interface if the host is 
> > unreachable in the beginning (e.g. ARP does not resolve) and then 
> > becomes reachable (ARP resolves).
> 
> Hmm, I've had a patch around for this code for a while now.  The code
> is simply wrong.  Does this work for you?

This patch solves "lockup" problem, but what about tons of equal 
conntracks?

I do not understand all logic beyond this, but perhaps tuples should get
linked in hashtable as they are created in prerouting/localout/whenever
and confirm would only increase refcount (and set appropriate bit in
status)?  This way kfree_skb of packet without confirmation would throw
conntrack out anyway, but while packets are sitting somewhere in the
stack, all "retransmissions" would get "accounted" for correct
conntrack.

Think about SYN retransmission - connection can be long over, but the 
duplicate (created because first syn was delayed) is still sitting 
around.


Karlis
