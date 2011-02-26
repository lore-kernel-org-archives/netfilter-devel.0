From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sun, 27 Feb 2011 00:42:03 +0100
Message-ID: <4D698FCB.6060205@netfilter.org>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org> <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020501090601090906060201"
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Changli Gao <xiaosuo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36236 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1BZXn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:43:28 -0500
In-Reply-To: <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020501090601090906060201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 26/02/11 22:45, Jozsef Kadlecsik wrote:
> On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:
>> I have test it here, it works fine. Let me know if you're OK with it.
> 
> The patch looks OK but I think Changli Gao is also right and it'd be 
> simpler to set the [reply][synack][SR] state to sIG. What do you think?

I read his email before leaving and after I made the new patch.

Indeed, his idea is simpler, here's a new patch. I tested it here, it
works fine.

Patrick, please apply!

--------------020501090601090906060201
Content-Type: text/x-patch;
 name="tcp-changli.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tcp-changli.patch"

Index: linux-2.6.37/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.37.orig/net/netfilter/nf_conntrack_proto_tcp.c	2011-02-26 20:14:44.000000000 +0000
+++ linux-2.6.37/net/netfilter/nf_conntrack_proto_tcp.c	2011-02-26 20:15:03.000000000 +0000
@@ -227,11 +227,11 @@
  *	sCL -> sIV
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*synack*/ { sIV, sSR, sSR, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
+/*synack*/ { sIV, sSR, sIG, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
 /*
  *	sSS -> sSR	Standard open.
  *	sS2 -> sSR	Simultaneous open
- *	sSR -> sSR	Retransmitted SYN/ACK.
+ *	sSR -> sIG	Retransmitted SYN/ACK, ignore it.
  *	sES -> sIG	Late retransmitted SYN/ACK?
  *	sFW -> sIG	Might be SYN/ACK answering ignored SYN
  *	sCW -> sIG

--------------020501090601090906060201--
