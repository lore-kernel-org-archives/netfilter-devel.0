From: Jason Lunz <lunz@falooley.org>
Subject: Re: [PATCH] admin-prohibited option. Let us look at it again.
Date: Wed, 21 May 2003 16:02:05 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <slrnbcn8rd.440.lunz@stoli.localnet>
References: <Pine.LNX.4.51.0304091927060.13250@dns.toxicfilms.tv>
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

solt@dns.toxicfilms.tv said:
> Harald wrote in:
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-December/009962.html
> 
> that we should add this option and make an INCOMPATIBILITIES file as Jozsef
> suggested. Also as Jozsef suggested this patch does not have kernel version
> checking, just a warning in the man page, the INCOMPATIBILITIES file and
> the '-j REJECT --help' message.
> 
> Please recall our exchange of opinions back then and review the patch to
> the netfilter tree:

I noticed that netfilter doesn't support rfc 1812 admin-prohibited
messages, and so I tracked down this thread and others in the archives.
I also found the patch to fix it in bugzilla bug #3 and the
patch-o-matic.

So my question is, since this has been known about since January and
netfilter 1.2.8 was released last month, what's holding up the inclusion
of this feature? What needs to be done to get it included? Why didn't it
go into 1.2.8? Not supporting RFC 1812 out of the box is a bug, IMO.

Also, I checked to see whether it was feasible to code it so that the
userspace could attempt to add an admin-prohibited rule, then fall back
to host- or -net-prohibited if that fails on the running kernel. The
problem is that it doesn't fail. In linux 2.4.20, the check() function
in ipt_REJECT.c doesn't care whether it recognizes the reject type or
not, and happily adds a rule with a bogus type if one is passed. Should
something like the patch below be applied?

Jason


--- net/ipv4/netfilter/ipt_REJECT.c.orig	Wed May 21 11:56:11 2003
+++ net/ipv4/netfilter/ipt_REJECT.c	Wed May 21 11:59:09 2003
@@ -353,6 +353,19 @@
 			DEBUGP("REJECT: TCP_RESET illegal for non-tcp\n");
 			return 0;
 		}
+	} else {
+		switch(rejinfo->with) {
+			case IPT_ICMP_NET_UNREACHABLE:
+			case IPT_ICMP_HOST_UNREACHABLE:
+			case IPT_ICMP_PROT_UNREACHABLE:
+			case IPT_ICMP_PORT_UNREACHABLE:
+			case IPT_ICMP_NET_PROHIBITED:
+			case IPT_ICMP_HOST_PROHIBITED:
+				break;
+			default:
+				printk(KERN_ERR "REJECT: invalid reject type.\n");
+				return 0;
+		}
 	}
 
 	return 1;
