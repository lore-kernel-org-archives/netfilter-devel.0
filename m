From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while data
 in unacknowledged
Date: Fri, 26 Jun 2009 19:03:00 +0200
Message-ID: <4A44FF44.5030006@trash.net>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain> <20080731063313.18150.27237.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0906261627500.2240@bizon.gios.gov.pl> <4A44E5DB.8000304@trash.net> <alpine.LNX.1.10.0906261827540.2240@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030009010901070707050501"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36051 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZFZRDC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:03:02 -0400
In-Reply-To: <alpine.LNX.1.10.0906261827540.2240@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030009010901070707050501
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
> On Fri, 26 Jun 2009, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>> This patch kills long living ftp transfers from one of my hosts. I'm 
>>> not able to transfer large files if it takes more than 
>>> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged seconds.
>>>
>>> After logging to the remote host and issuing any FTP command (ls or 
>>> put/get for example) tuple's timeout is reduced. Additional commands 
>>> are able to bump it but only upto 
>>> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged.
>>>
>>> It seems that IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED flag is never cleard.
>>>
>>> Tested on 2.6.28.10.
>>
>> Interesting, are you using the FTP NAT helper?
> 
> Actually, yes :)
> 
>> I'm guessing there is some bad interaction between sequence number
>> adjustments when changing the packet sizes and sequence number
>> tracking in conntrack.
> 
> Very likely, src ip and nat ip have different lengths.

I think I know what the problem is. We update the highest seen
sequence number when adjusting packet lengths in NAT, but only
upwards:

void nf_conntrack_tcp_update(const struct sk_buff *skb,
			     unsigned int dataoff,
			     struct nf_conn *ct,
			     int dir)
{
...
	if (after(end, ct->proto.tcp.seen[dir].td_end))
		ct->proto.tcp.seen[dir].td_end = end;

So I'm guessing in your case, the NAT address is shorter than
the original one.

This patch changes TCP conntrack to update the highest sequence
number when the old number matches the new one + the size offset,
so it should effectively update it after NAT whenever the packet
caused an update before NAT.

Please test whether this patch fixes the problem.


--------------030009010901070707050501
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a632689..cbdd628 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -258,8 +258,8 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 /* Update TCP window tracking data when NAT mangles the packet */
 extern void nf_conntrack_tcp_update(const struct sk_buff *skb,
 				    unsigned int dataoff,
-				    struct nf_conn *ct,
-				    int dir);
+				    struct nf_conn *ct, int dir,
+				    s16 offset);
 
 /* Fake conntrack entry for untracked connections */
 extern struct nf_conn nf_conntrack_untracked;
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 155c008..09172a6 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -191,7 +191,8 @@ nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 				    ct, ctinfo);
 		/* Tell TCP window tracking about seq change */
 		nf_conntrack_tcp_update(skb, ip_hdrlen(skb),
-					ct, CTINFO2DIR(ctinfo));
+					ct, CTINFO2DIR(ctinfo),
+					(int)rep_len - (int)match_len);
 
 		nf_conntrack_event_cache(IPCT_NATSEQADJ, ct);
 	}
@@ -377,6 +378,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	struct tcphdr *tcph;
 	int dir;
 	__be32 newseq, newack;
+	s16 seqoff, ackoff;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way, *other_way;
 
@@ -390,15 +392,18 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 
 	tcph = (void *)skb->data + ip_hdrlen(skb);
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
-		newseq = htonl(ntohl(tcph->seq) + this_way->offset_after);
+		seqoff = this_way->offset_after;
 	else
-		newseq = htonl(ntohl(tcph->seq) + this_way->offset_before);
+		seqoff = this_way->offset_before;
 
 	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
 		  other_way->correction_pos))
-		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_after);
+		ackoff = other_way->offset_after;
 	else
-		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_before);
+		ackoff = other_way->offset_before;
+
+	newseq = htonl(ntohl(tcph->seq) + seqoff);
+	newack = htonl(ntohl(tcph->ack_seq) - ackoff);
 
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, 0);
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->ack_seq, newack, 0);
@@ -413,7 +418,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	if (!nf_nat_sack_adjust(skb, tcph, ct, ctinfo))
 		return 0;
 
-	nf_conntrack_tcp_update(skb, ip_hdrlen(skb), ct, dir);
+	nf_conntrack_tcp_update(skb, ip_hdrlen(skb), ct, dir, seqoff);
 
 	return 1;
 }
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 33fc0a4..97a82ba 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -720,8 +720,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
 /* Caller must linearize skb at tcp header. */
 void nf_conntrack_tcp_update(const struct sk_buff *skb,
 			     unsigned int dataoff,
-			     struct nf_conn *ct,
-			     int dir)
+			     struct nf_conn *ct, int dir,
+			     s16 offset)
 {
 	const struct tcphdr *tcph = (const void *)skb->data + dataoff;
 	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[dir];
@@ -734,7 +734,7 @@ void nf_conntrack_tcp_update(const struct sk_buff *skb,
 	/*
 	 * We have to worry for the ack in the reply packet only...
 	 */
-	if (after(end, ct->proto.tcp.seen[dir].td_end))
+	if (ct->proto.tcp.seen[dir].td_end + offset == end)
 		ct->proto.tcp.seen[dir].td_end = end;
 	ct->proto.tcp.last_end = end;
 	spin_unlock_bh(&ct->lock);

--------------030009010901070707050501--
