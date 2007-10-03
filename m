From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 3 Oct 2007 15:54:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:58909 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbXJCOUw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:20:52 -0400
In-Reply-To: <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Wed, 3 Oct 2007, Krzysztof Oledzki wrote:

> I also wondering if the code from nf_conntrack_proto_tcp.c is correct:
[...]

I think the code segment is correct. However, the end of the segment 
is miscalculated by segment_seq_plus_len because the offset added to 
'dataoff' by the get_l4proto function of IPv4/IPv6 is not taken into 
account. Please check whether the patch below fixes it:

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.23-rc4-orig/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.23-rc4-tcp_win/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.23-rc4-orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-08-28 03:32:35.000000000 +0200
+++ linux-2.6.23-rc4-tcp_win/net/netfilter/nf_conntrack_proto_tcp.c	2007-10-03 15:44:01.000000000 +0200
@@ -509,7 +509,8 @@
 	seq = ntohl(tcph->seq);
 	ack = sack = ntohl(tcph->ack_seq);
 	win = ntohs(tcph->window);
-	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
+	end = segment_seq_plus_len(seq, skb->len, 
+				   dataoff - skb_network_offset(skb), tcph);
 
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
 		tcp_sack(skb, dataoff, tcph, &sack);


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
