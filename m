From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] ip_nat_ftp doesn't register any ports by default.
Date: Thu, 16 Sep 2004 08:07:06 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095286006.1940.5.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Linus, please apply ASAP.  This would be embarrassing: ip_nat_ftp broke
in recent conversion to module_param_array().

Name: Fix ip_nat_ftp registration when no ports= arg
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

FTP NAT module doesn't register anything with no args.  Oops.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6124-linux-2.6.9-rc2-bk2/net/ipv4/netfilter/ip_nat_ftp.c .6124-linux-2.6.9-rc2-bk2.updated/net/ipv4/netfilter/ip_nat_ftp.c
--- .6124-linux-2.6.9-rc2-bk2/net/ipv4/netfilter/ip_nat_ftp.c	2004-09-16 00:17:16.000000000 +1000
+++ .6124-linux-2.6.9-rc2-bk2.updated/net/ipv4/netfilter/ip_nat_ftp.c	2004-09-16 08:05:38.000000000 +1000
@@ -297,7 +297,7 @@ static int __init init(void)
 	char *tmpname;
 
 	if (ports_c == 0)
-		ports[ports_c] = FTP_PORT;
+		ports[ports_c++] = FTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;

-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
