From: Jerome Borsboom <netfilter-devel@knorkaan.com>
Subject: Re: [PATCH] Conntrack SIP Problem
Date: Mon, 18 Jun 2007 14:47:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706181445380.26309@knorkaan.xs4all.nl>
References: <Pine.LNX.4.64.0706161524130.980@knorkaan.xs4all.nl>
	<46767BF1.9070904@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46767BF1.9070904@trash.net>
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

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>

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

On Mon, 18 Jun 2007, Patrick McHardy wrote:

> Thanks. They both look OK, but for 2.6.22 I'm only going to add
> the new message types. I'll queue the first chunk for 2.6.23.
> Can you please send me a Signed-off-by: line for your patch?
>
>
