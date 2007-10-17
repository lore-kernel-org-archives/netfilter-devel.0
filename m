From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 17 Oct 2007 19:41:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710171935320.26023@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710122002020.10132@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:50186 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532AbXJQRlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:41:08 -0400
In-Reply-To: <Pine.LNX.4.64.0710122002020.10132@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Oct 2007, Krzysztof Oledzki wrote:

> > Could you send me a pcap file captured with '-s 0'? Then I could replay it
> > and see what happens.
> 
> Attached.

Thank you, that was really useful. So instead of the patch I sent last 
time about active close, please apply the patch below: setting the 
last_dir parameter was missing from the previous one.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1b836d0..67b39b8 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -834,9 +834,11 @@ static int tcp_packet(struct nf_conn *conntrack,
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
-		if (conntrack->proto.tcp.seen[!dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT) {
-			/* Attempt to reopen a closed connection.
+		if ((conntrack->proto.tcp.seen[!dir].flags & 
+			IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || (conntrack->proto.tcp.last_dir == dir
+		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
+			/* Attempt to reopen a closed/aborted connection.
 			* Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
 			if (del_timer(&conntrack->timeout))
@@ -925,6 +927,7 @@ static int tcp_packet(struct nf_conn *conntrack,
      in_window:
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
+	conntrack->proto.tcp.last_dir = dir;
 
 	pr_debug("tcp_conntracks: ");
 	NF_CT_DUMP_TUPLE(tuple);

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
