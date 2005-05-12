From: Oliver Korpilla <Oliver.Korpilla@gmx.de>
Subject: Packet Injection
Date: Thu, 12 May 2005 13:55:05 +0200
Message-ID: <42834419.3060302@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello!

I'm new to the list, and what I've found in the list archives regarding
packet injection is somewhat lacking in detail.

What I want to do:

I want to write a tool that sends and receives packets within the kernel
context. It's generates traffic on one interface and receives the result
of some blackbox modification to it on another interface.

So I need both packet filtering / netfilter like capabilities and packet
injection capabilities.

While the way to go for the receiving end of the application is pretty
straightforward, my question is: How to inject packets inside the kernel?

One idea was to create the packets externally, store them in kernel RAM,
and use netfilter hooks to inject them. The injection would be done by a
linux kernel module or rather by a periodic tasklet registered by that
module.

Can you comment whether this is a feasible approach?

Or could you come up with a better one, that fulfills the requirement of
being in-kernel?

Thanks and with kind regards,
Oliver Korpilla
