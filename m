From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Tue, 28 Oct 2003 22:59:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9EE6C8.AE3F16DA@fy.chalmers.se>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se> <3F9E292C.3020509@trash.net> <3F9E3E6C.C0CC5598@fy.chalmers.se> <3F9E406C.7050105@trash.net> <3F9E506A.BD4BA635@fy.chalmers.se> <3F9E5EE6.1090103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------740384F81B1BEB2668BB8288"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------740384F81B1BEB2668BB8288
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> >Yes, it does [imply that]. But I rather wonder why did it assemble a TCP
> >packet larger than MTU in first place. But in either case it looks like
> >whomever who did that gives up after 3 seconds and generates two smaller
> >instead. Normally I would also complain that one would expect tcpdump to
> >show wire traffic even on the client side, but this is really bad
> >opportunity to do so, as we probably wouldn't land on ip_refrag so
> >soon:-)
> 
> Yes you're right the stack should never generate tcp packets > mtu.
> 
> This is either a misconfiguration or a bug in TCP.

Looks like neither:-) My NIC turned to be NETIF_F_TSO capable, which
means that it "can off-load TCP/IP segmentation" and kernel is allowed
to and does throw packets larger than ethernet MTU at it [and tcpdump
therefore was honest].

I'm currently running attached patch and it apparently solves my
*particular* problem, but I can't tell if it's actually "the right
thing(tm)" to do... Is (*pskb)->sk->sk_route_caps right place to check?
Maybe out->features is more appropriate? Is there TSO maximum which one
should compare (*pskb)->len against? That kind of questions...

HOWEVER!!! Even if we figure out "the right thing(tm)" and address the
NETIF_F_TSO issue in proper manner, it does *not* necessarily mean that
performance problem will disappear as well. Well, in my optinion... I
mean performance might still suffer, whenever user will for example
masquerade a larger MTU interface behind "narrower" one, e.g. behind
PPPoE virtual interface, and further experiments should therefore be
performed... But I'm not sure if I'll be able to assist, because my
NETIF_F_TSO capable NIC might make it impossible to arrange for proper
setup [without PPPoE which I simply don't have]. I'll try, but can't
make any promises... Cheers. A.
--------------740384F81B1BEB2668BB8288
Content-Type: text/plain; charset=us-ascii;
 name="nf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf.diff"

--- ./net/ipv4/netfilter/ip_conntrack_standalone.c.orig	Sat Oct 25 20:43:32 2003
+++ ./net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Oct 28 23:16:56 2003
@@ -198,6 +198,9 @@
 	if (ip_confirm(hooknum, pskb, in, out, okfn) != NF_ACCEPT)
 		return NF_DROP;
 
+	if ((*pskb)->sk && (*pskb)->sk->sk_route_caps&NETIF_F_TSO)
+		return NF_ACCEPT;
+
 	/* Local packets are never produced too large for their
 	   interface.  We degfragment them at LOCAL_OUT, however,
 	   so we have to refragment them here. */

--------------740384F81B1BEB2668BB8288--
