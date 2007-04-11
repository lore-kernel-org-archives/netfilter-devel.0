From: anonymousnfhacker-not-a-valid-address@dev-null-invalid.com
Subject: Using both mangle and nat tables together
Date: Wed, 11 Apr 2007 06:56:37 +0000 (UTC)
Message-ID: <11759.9866506227$1176274597@news.gmane.org>
Reply-To: netfilter-devel@lists.netfilter.org
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Netfilter developers,

I have my own target module that works perfectly fine in the mangle table.
It modifies various parts of the IP header. A POSTROUTING rule changes
packets on the way out, and a PREROUTING rule changes packets back to
normal on the way back in. In addition, I would like to be able to use my
module along with a SNAT rule in the POSTROUTING chain of the nat table.
My problem is that I don't know how each of the POSTROUTING rules would be
evaluated together since they are both POSTROUTING chains.

If I only insert my SNAT rule in the nat table, my packets are properly
changed as specified. If I only insert my target rule in the mangle table,
my packets also properly changed as specified. But when I use both sets of
rules together, only my target is evaluated, and NOT the SNAT rule.

In my hook functions, I always return IPT_CONTINUE when I successfully
modify a packet. I know this works, because if I insert additional rules i
nthe mangle table after my rules, they also get evaluated. But it seems
that the packets I modify (that match my mangle rules) do not get
evaluated by the nat table. How can I ensure that packets are evaluated
both by my mangle table rules and the nat table rules?

I haven't messed around with connection tracking yet, because I don't need
to at this point (that I know if). Do I need to add in some connection
tracking information in my hooks to ensure the packets also traverse the
POSTROUTING chain in the nat table?

Any help would be appreciated. I'm signed up on the list under my real
e-mail address so I should receive responses sent to the list. Thank you.

anonymousnfhacker
