From: Jerome Borsboom <netfilter-devel@knorkaan.com>
Subject: [PATCH] Conntrack SIP Problem
Date: Sat, 16 Jun 2007 15:33:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706161524130.980@knorkaan.xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

This is a CC of a patch from my discussion on linux-net mailinglist which 
may be also appropriate here.

Below is a patch that I had to include on top of Herbert Xu's recent 
nat-sip patch to get my SIP setup working:

     [NETFILTER]: sip: Fix RTP address NAT

My setup is a Fritzbox SIP-client behind a NAT-firewall that talks to a 
server on the internet. The first chunk of the patch was not necessary to 
get the setup working, but I think it is more correct to include it. The 
idea behind it is that DNAT of the the RTP session is only necessary if 
the SIP session has been SNATed. The second chunk adds some SIP messages 
that must be processed as they contain SDP information in my case.


Regards,
Jerome

--- linux-2.6.21/net/ipv4/netfilter/nf_nat_sip.c	2007-06-16 12:14:42.000000000 +0200
+++ linux-2.6.21.new/net/ipv4/netfilter/nf_nat_sip.c	2007-06-16 12:04:07.000000000 +0200
@@ -259,7 +259,11 @@
  	DEBUGP("ip_nat_sdp():\n");

  	/* Connection will come from reply */
-	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+	if (ct->tuplehash[dir].tuple.src.u3.ip ==
+	    ct->tuplehash[!dir].tuple.dst.u3.ip)
+		newip = exp->tuple.dst.u3.ip;
+	else
+		newip = ct->tuplehash[!dir].tuple.dst.u3.ip;

  	exp->saved_ip = exp->tuple.dst.u3.ip;
  	exp->tuple.dst.u3.ip = newip;
--- linux-2.6.21/net/netfilter/nf_conntrack_sip.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.21.new/net/netfilter/nf_conntrack_sip.c	2007-06-16 11:16:02.000000000 +0200
@@ -442,6 +442,9 @@

  	/* RTP info only in some SDP pkts */
  	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) != 0 &&
+	    memcmp(dptr, "UPDATE", sizeof("UPDATE") - 1) != 0 &&
+           memcmp(dptr, "SIP/2.0 180", sizeof("SIP/2.0 180") - 1) != 0 &&
+           memcmp(dptr, "SIP/2.0 183", sizeof("SIP/2.0 183") - 1) != 0 &&
  	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) != 0) {
  		goto out;
  	}
