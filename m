From: Patrick McHardy <kaber@trash.net>
Subject: Re: ECN target bug report
Date: Tue, 10 Dec 2002 00:02:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF52111.8080405@trash.net>
References: <3DF1F442.806@istitutocolli.org> <3DF508CA.6000107@istitutocolli.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070600030709070709050305"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrea Rossato <mailing_list@istitutocolli.org>
In-Reply-To: <3DF508CA.6000107@istitutocolli.org>
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
--------------070600030709070709050305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrea,

the first attached patch fixes the issue you reported (verified), 
altough i'm not entirely sure why ;).
the second one is untested but probably couldn't hurt neither.

bye,
patrick

Andrea Rossato wrote:

> attached you will find 3 patches. the first one is an attempt to prove 
> the existence of the problem. the second is just a hack that provides 
> a temporary solution it's just a workaround: packets with ec e cwr 
> bits set and good checksum will be stripped and checksum recalculated 
> from scratch.
>
> The problem, as far as I can see it, could be located in csum_partial 
> (arch/i386/lib/checksum.S, meaning a platform dependent problem): i'm 
> not a kernel hacker (i'm a lawyer, a legal scholar actually), but i do 
> not see any mistake in the way partial checksum is carried out in 
> tcp_etc_set. anyway checksum after partial or total recalculation 
> differ. That's a fact. Evidence of the fact  can be gained with the 
> second patch: in this case the kernel will log the checksum after 
> partial recalculation and after total recalculation (that means that 
> two calculations will take place). The two values differ!
>
> Thanks for your attention.
>
> 1. check the bug:
> echo 1 /proc/sys/net/ipv4/tcp_ecn
> iptables -A OUTPUT -t mangle -o ppp0 -p tcp -d my.host.org --dport 80 
> -j ECN --ecn-tcp-remove
> iptables -A OUTPUT -o ppp0 -p tcp -d my.host.org --dport 80 -m unclean 
> -j DROP
> packets will be dropped
>
> 2. apply one of the patches and try again:
> packets will get though and the connection will be established.
>
> andrea
>

--------------070600030709070709050305
Content-Type: text/plain;
 name="ipt_ECN.diff.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ECN.diff.1"

--- net/ipv4/netfilter/ipt_ECN.c.orig	2002-12-09 23:14:20.000000000 +0100
+++ net/ipv4/netfilter/ipt_ECN.c	2002-12-09 23:13:27.000000000 +0100
@@ -88,8 +88,8 @@
 	}
 	
 	if (diffs[0] != *tcpflags) {
-		diffs[0] = htons(diffs[0]) ^ 0xFFFF;
-		diffs[1] = htons(*tcpflags);
+		diffs[0] = diffs[0] ^ 0xFFFF;
+		diffs[1] = *tcpflags;
 		tcph->check = csum_fold(csum_partial((char *)diffs,
 		                                    sizeof(diffs),
 		                                    tcph->check^0xFFFF));

--------------070600030709070709050305
Content-Type: text/plain;
 name="ipt_ECN.diff.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_ECN.diff.2"

--- net/ipv4/netfilter/ipt_ECN.c.orig	2002-12-09 23:14:20.000000000 +0100
+++ net/ipv4/netfilter/ipt_ECN.c	2002-12-09 23:25:54.000000000 +0100
@@ -41,10 +41,10 @@
 			iph = (*pskb)->nh.iph;
 		}
 
-		diffs[0] = htons(iph->tos) ^ 0xFFFF;
+		diffs[0] = iph->tos ^ 0xFF;
 		iph->tos = iph->tos & ~IPT_ECN_IP_MASK;
 		iph->tos = iph->tos | (einfo->ip_ect & IPT_ECN_IP_MASK);
-		diffs[1] = htons(iph->tos);
+		diffs[1] = iph->tos;
 		iph->check = csum_fold(csum_partial((char *)diffs,
 		                                    sizeof(diffs),
 		                                    iph->check^0xFFFF));

--------------070600030709070709050305--
