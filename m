From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Change proposal for consistent "skb->pkt_type" after re-injection
Date: Wed, 30 Jun 2004 12:43:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301239040.3767-100000@filer.marasystems.com>
References: <20040629094835.GA3141@rie.rie.priv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <bus@fgan.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>
In-Reply-To: <20040629094835.GA3141@rie.rie.priv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 29 Jun 2004, Christian Riechmann wrote:

> Apparantly the skb->pkt_type is set very early within one of the
> kernel IP routines passed by the broadcasted or multicasted packet
> BEFORE iptables gave it to the user space program and the
> modified (now TCP packet with a host address) packet is re-injected
> into the kernel processing.

Correct, and ip_queue does not have an option to let the userspace return 
a new packet type. But there is other iptables modules allowing you to do 
this kind of thing either before or after the packet is sent to ip_queue.

> One - bad - solution for this problem could be to delete the above
> test within the TCP functions, but this would produce difficulties,
> if some people (hacker?) would send IP/TCP packets with multicast or
> broadcast addresses.

Deleting these tests from TCP would cause serious problems. These tests 
exists there for good reasons.

> As a better solution I would propose, that the processing initiated
> by ipq_set_verdict should update the packet type (skb->pkt_type)
> according to the re-injected packet.

How would it know? The packet type is dictated by how the packet arrived 
to the box, not the IP content.


But honestly I would recommend reinjecting the packets via a TUN device.  
This way a whole can of problems is avioded with very little complexity. I
would even get the encapsulated packets out of the kernel via the same TUN
device and just use iptables to have them routed there but that it me.

Regards
Henrik
