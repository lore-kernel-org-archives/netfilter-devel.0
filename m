From: Michael Jung <michaj@cs.tu-berlin.de>
Subject: Netfilter: Ensuring serial packet delivery to the hooks ?
Date: Thu, 30 Oct 2003 15:10:32 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.SOL.4.56.0310301455410.18298@fiesta>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Netfilter Team !

I have a question related to the kind of packet delivery in Netfilter.

I want to make some packet checks on hook PREROUTING and LOCALOUT.
(That is the combination where I get all packets without doing the
 same checks on the same packet multiple times, because a packet may
 pass several hooks on one host.)

May problem is, that the result of these checks must be known and
applicable on all other hooks like FORWARD, where my program does
other packet mangling things.

So, can I set a global flag when a packet passes PREROUTING or
LOCALOUT, and then use this flag on hook FORWARD ?
May be, that at the time between the hooks PREROUTING (or LOCALOUT)
and FORWARD another packet could come from the network (or process).
This second packet will be handled regularly by my check routine on
PREROUTING (or LOCALOUT). This would change the global flag and I
will loose my first result related to the first packet, which will
pass FORWARD soon.

My direct question:  Does Netfilter ensure that each packet passes
all hooks for which it is directed, before the next packet enters
the hook chain ?

Mic
