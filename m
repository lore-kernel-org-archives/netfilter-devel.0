From: Marco Innocenti <dot0037@iperbole.bologna.it>
Subject: [PATCH] NETFILTER: add support for invert condition (!) in ipt_limit
Date: Mon, 17 Oct 2005 11:34:33 +0200
Message-ID: <20051017093433.GA25948@pc-innocenti.cineca.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Add support for invert condition (!) in ipt_limit.

Signed-off-by: Marco Innocenti <m.innocenti@cineca.it>

---
Hi, this is my first patch and I hope I followed the guideline.
The patch change the kernel and iptables. Should I have sent two mail?


diff -uprN linux-2.6.13.4/include/linux/netfilter_ipv4/ipt_limit.h linux-2.6.13.4.mio/include/linux/netfilter_ipv4/ipt_limit.h
--- linux-2.6.13.4/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-10 20:54:29.000000000 +0200
+++ linux-2.6.13.4.mio/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-15 16:25:02.000000000 +0200
@@ -9,6 +9,7 @@
 struct ipt_rateinfo {
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
+	u_int8_t invert;
 
 	/* Used internally by the kernel */
 	unsigned long prev;
diff -uprN linux-2.6.13.4/net/ipv4/netfilter/ipt_limit.c linux-2.6.13.4.mio/net/ipv4/netfilter/ipt_limit.c
--- linux-2.6.13.4/net/ipv4/netfilter/ipt_limit.c	2005-10-10 20:54:29.000000000 +0200
+++ linux-2.6.13.4.mio/net/ipv4/netfilter/ipt_limit.c	2005-10-15 16:30:23.000000000 +0200
@@ -82,11 +82,11 @@ ipt_limit_match(const struct sk_buff *sk
 		/* We're not limited. */
 		r->credit -= r->cost;
 		spin_unlock_bh(&limit_lock);
-		return 1;
+		return 1 ^ r->invert;
 	}
 
        	spin_unlock_bh(&limit_lock);
-	return 0;
+	return 0 ^ r->invert;
 }
 
 /* Precision saver. */
+diff -upNr iptables-1.3.3/extensions/libipt_limit.c iptables-1.3.3.mio/extensions/libipt_limit.c
--- iptables-1.3.3/extensions/libipt_limit.c	2005-02-19 20:19:17.000000000 +0100
+++ iptables-1.3.3.mio/extensions/libipt_limit.c	2005-10-16 21:44:24.000000000 +0200
@@ -23,7 +23,7 @@ help(void)
 {
 	printf(
 "limit v%s options:\n"
-"--limit avg			max average match rate: default "IPT_LIMIT_AVG"\n"
+"[!] --limit avg			max average match rate: default "IPT_LIMIT_AVG"\n"
 "                                [Packets per second unless followed by \n"
 "                                /sec /minute /hour /day postfixes]\n"
 "--limit-burst number		number to match in a burst, default %u\n"
@@ -121,8 +121,7 @@ parse(int c, char **argv, int invert, un
 	}
 
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "limit does not support invert");
+		r->invert = 1;
 
 	return 1;
 }
@@ -161,6 +160,8 @@ print(const struct ipt_ip *ip,
       int numeric)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)match->data;
+	if (r->invert)
+		printf("! ");
 	printf("limit: avg "); print_rate(r->avg);
 	printf("burst %u ", r->burst);
 }
diff -upNr iptables-1.3.3/include/linux/netfilter_ipv4/ipt_limit.h iptables-1.3.3.mio/include/linux/netfilter_ipv4/ipt_limit.h
--- iptables-1.3.3/include/linux/netfilter_ipv4/ipt_limit.h	2004-10-10 11:56:23.000000000 +0200
+++ iptables-1.3.3.mio/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-16 21:34:43.000000000 +0200
@@ -9,6 +9,7 @@
 struct ipt_rateinfo {
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
+	u_int8_t invert;
 
 #ifdef KERNEL_64_USERSPACE_32
 	u_int64_t prev;


-- 
Ciao
     Marco Innocenti
