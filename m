From: Patrick McHardy <kaber@trash.net>
Subject: Re: Deadlocks
Date: Tue, 15 Jun 2004 08:23:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CE95DE.9090703@trash.net>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090607010502040709030101"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040615044723.GA16891@linuxace.com>
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
--------------090607010502040709030101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Phil Oester wrote:
> I agree I am likely experiencing the deadlock you refer to:
> 
> CPU1:
> conntrack-helper:help: lock(private_lock)
> ip_conntrack_expect_related: write_lock(ip_conntrack_lock)
> 
> CPU2:
> nat-core:do_bindings: read_lock(ip_conntrack_lock)
> nat-helper:help: lock(private_lock)
> 
> However, it's unclear to me that the ip_ftp_lock can be trivially eliminated.
> 
> This code path looks particularly prickly in ip_nat_ftp.c:
> 
> help
>   ftp_data_fixup
>     ip_conntrack_change_expect
> 
> so the nat helper is changing the expectation -- potentially at the same time
> the conntrack helper is calling ip_conntrack_expect.  If the private lock
> were removed, could this not cause a race condition if the expectation got
> created just after the nat-helper changed the expectation?  

I don't understand what you mean. The nat-helper can not change the
expectation before it's created, and once it's created it can not
be touched by the conntrack helper anymore. ip_ftp_lock is protecting
ftp_buffer and ct_ftp_info, so it can be dropped directly after the
call to find_pattern. The help function in the nat_helper only touches
the expectation, which is protected by ip_conntrack_lock, so it doesn't
need ip_ftp_lock lock at all.

> 
> It seems the ip_ftp_lock is needed, but perhaps needs to be reworked to avoid
> the deadlock condition illustrated above.

I've attached an untested patch which should fix this problem for the
ftp helper. Care to give it a try ?

Regards
Patrick

> 
> Thoughts?
> 
> Phil

--------------090607010502040709030101
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== include/linux/netfilter_ipv4/ip_conntrack_ftp.h 1.4 vs edited =====
--- 1.4/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2002-08-19 20:41:51 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2004-06-15 08:20:59 +02:00
@@ -4,11 +4,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/netfilter_ipv4/lockhelp.h>
-
-/* Protects ftp part of conntracks */
-DECLARE_LOCK_EXTERN(ip_ftp_lock);
-
 #define FTP_PORT	21
 
 #endif /* __KERNEL__ */
===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.19 vs edited =====
--- 1.19/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-03-30 06:18:56 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-06-15 08:20:28 +02:00
@@ -27,7 +27,7 @@
 /* This is slow, but it's simple. --RR */
 static char ftp_buffer[65536];
 
-DECLARE_LOCK(ip_ftp_lock);
+static DECLARE_LOCK(ip_ftp_lock);
 struct module *ip_conntrack_ftp = THIS_MODULE;
 
 #define MAX_PORTS 8
@@ -327,6 +327,7 @@
 				     search[i].getnum);
 		if (found) break;
 	}
+	UNLOCK_BH(&ip_ftp_lock);
 	if (found == -1) {
 		/* We don't usually drop packets.  After all, this is
 		   connection tracking, not packet filtering.
@@ -336,12 +337,9 @@
 			printk("conntrack_ftp: partial %s %u+%u\n",
 			       search[i].pattern,
 			       ntohl(tcph.seq), datalen);
-		ret = NF_DROP;
-		goto out;
-	} else if (found == 0) { /* No match */
-		ret = NF_ACCEPT;
-		goto out;
-	}
+		return NF_DROP;
+	} else if (found == 0) /* No match */
+		return NF_ACCEPT;
 
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
 	       (int)matchlen, data + matchoff,
@@ -349,11 +347,8 @@
 
 	/* Allocate expectation which will be inserted */
 	exp = ip_conntrack_expect_alloc();
-	if (exp == NULL) {
-		ret = NF_ACCEPT;
-		goto out;
-	}
-
+	if (exp == NULL)
+		return NF_ACCEPT;
 	exp_ftp_info = &exp->help.exp_ftp_info;
 
 	/* Update the ftp info */
@@ -376,10 +371,8 @@
 		   <lincoln@cesar.org.br> for reporting this potential
 		   problem (DMZ machines opening holes to internal
 		   networks, or the packet filter itself). */
-		if (!loose) {
-			ret = NF_ACCEPT;
-			goto out;
-		}
+		if (!loose)
+			return NF_ACCEPT;
 	}
 
 	exp->tuple = ((struct ip_conntrack_tuple)
@@ -397,7 +390,8 @@
 
 	/* Ignore failure; should only happen with NAT */
 	ip_conntrack_expect_related(exp, ct);
-	ret = NF_ACCEPT;
+	return NF_ACCEPT;
+
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
@@ -457,7 +451,6 @@
 }
 
 PROVIDES_CONNTRACK(ftp);
-EXPORT_SYMBOL(ip_ftp_lock);
 
 module_init(init);
 module_exit(fini);
===== net/ipv4/netfilter/ip_nat_ftp.c 1.13 vs edited =====
--- 1.13/net/ipv4/netfilter/ip_nat_ftp.c	2004-01-29 00:59:33 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_ftp.c	2004-06-15 08:23:13 +02:00
@@ -37,8 +37,6 @@
 MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
 #endif
 
-DECLARE_LOCK_EXTERN(ip_ftp_lock);
-
 /* FIXME: Time out? --RR */
 
 static unsigned int
@@ -61,8 +59,6 @@
 	DEBUGP("nat_expected: We have a connection!\n");
 	exp_ftp_info = &ct->master->help.exp_ftp_info;
 
-	LOCK_BH(&ip_ftp_lock);
-
 	if (exp_ftp_info->ftptype == IP_CT_FTP_PORT
 	    || exp_ftp_info->ftptype == IP_CT_FTP_EPRT) {
 		/* PORT command: make connection go to the client. */
@@ -77,7 +73,6 @@
 		DEBUGP("nat_expected: PASV cmd. %u.%u.%u.%u->%u.%u.%u.%u\n",
 		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
 	}
-	UNLOCK_BH(&ip_ftp_lock);
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
 		newip = newsrcip;
@@ -113,8 +108,6 @@
 {
 	char buffer[sizeof("nnn,nnn,nnn,nnn,nnn,nnn")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "%u,%u,%u,%u,%u,%u",
 		NIPQUAD(newip), port>>8, port&0xFF);
 
@@ -136,8 +129,6 @@
 {
 	char buffer[sizeof("|1|255.255.255.255|65535|")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "|1|%u.%u.%u.%u|%u|", NIPQUAD(newip), port);
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
@@ -158,8 +149,6 @@
 {
 	char buffer[sizeof("|||65535|")];
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
-
 	sprintf(buffer, "|||%u|", port);
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
@@ -191,7 +180,6 @@
 	u_int16_t port;
 	struct ip_conntrack_tuple newtuple;
 
-	MUST_BE_LOCKED(&ip_ftp_lock);
 	DEBUGP("FTP_NAT: seq %u + %u in %u\n",
 	       expect->seq, ct_ftp_info->len,
 	       ntohl(tcph->seq));
@@ -270,15 +258,12 @@
 	}
 
 	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
-	LOCK_BH(&ip_ftp_lock);
 	/* If it's in the right range... */
 	if (between(exp->seq + ct_ftp_info->len,
 		    ntohl(tcph->seq),
 		    ntohl(tcph->seq) + datalen)) {
-		if (!ftp_data_fixup(ct_ftp_info, ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_ftp_lock);
+		if (!ftp_data_fixup(ct_ftp_info, ct, pskb, ctinfo, exp))
 			return NF_DROP;
-		}
 	} else {
 		/* Half a match?  This means a partial retransmisison.
 		   It's a cracker being funky. */
@@ -288,11 +273,8 @@
 			       ntohl(tcph->seq),
 			       ntohl(tcph->seq) + datalen);
 		}
-		UNLOCK_BH(&ip_ftp_lock);
 		return NF_DROP;
 	}
-	UNLOCK_BH(&ip_ftp_lock);
-
 	return NF_ACCEPT;
 }
 

--------------090607010502040709030101--
