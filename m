From: Jason Lunz <lunz@falooley.org>
Subject: --reject-with admin-prohibited (again)
Date: Fri, 23 May 2003 21:11:20 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <slrnbct3nf.2md.lunz@stoli.localnet>
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

I was wondering about implementing rfc1812 icmp-admin-prohibited, so I
found the threads on this topic in the archives, and looked at the
patches that implement it. Since the big problem seems to be
compatibility, I checked whether it was feasible to try and add rules
with the new reject type and fall back to net-prohibited if that failed
on the running kernel.

The problem is that adding an unrecognized reject type on an old kernel
doesn't fail. The ipt_REJECT.c kernel module silently adds the rule but
never sends the reject packet when it triggers. Shouldn't something like
the patch below be added to the kernel? 

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
