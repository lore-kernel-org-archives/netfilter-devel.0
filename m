From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Change proposal for consistent "skb->pkt_type" after re-injection
Date: Mon, 5 Jul 2004 22:56:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407052240110.28889-100000@filer.marasystems.com>
References: <20040705193414.GA985@rie.rie.priv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <bus@fgan.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>
In-Reply-To: <20040705193414.GA985@rie.rie.priv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 5 Jul 2004, Christian Riechmann wrote:

> Therefore,
> why not a patch which resets skb->pkt_type according to the address of
> the re-injected packet?

Because pkt_type is not about the address of the packet, it is about how
the packet arrived to the box. pkt_type is link level, not IP level. You
can not deduce pkt_type from the IP level as the needed information is not
there.

What you can maybe do if you really want to do this kind of packet
modifications via QUEUE is to extend ip_queue to also allow modification
of pkt_type, not only payload. But I strongly advice you to reinject the
packets via a TUN device rather than modifying them "inline", and would
also recommend intercepting the packets via a TUN device but you may use
QUEUE for this if somehow more suitable for your solution (just remember
to return NF_DROP verdict to stop the original packet). But be warned that
you will still need to consider the effects on conntrack from you stealing
the packet mid-flight if you ever consider using conntrack on the same
system, but with the packets being broadcasts conntrack should not be much 
of an issue I think..

Thinking about the interception.. why do you even need to intercept? Can't
you simply accept the packets? I don't remember exactly what kind of
encapsulation you are using other than that the transport packets is
broadcasted.. but if the transport protocol is something understandable 
then just having a socket accepting these packets should be sufficient to 
have them delivered to your userspace application with considerably less 
complexity than using ip_queue.

Regards
Henrik
