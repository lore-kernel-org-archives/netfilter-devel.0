From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP LAST ACK incorrectly treated as invalid
Date: Wed, 22 Oct 2014 21:37:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410222039170.7882@blackhole.kfki.hu>
References: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com> <alpine.DEB.2.10.1410210852310.27469@blackhole.kfki.hu> <CAC=w+U5v6oj0zJFTZvjPomyf+pFdFCJrXgdWVG7QQDuttuhC1g@mail.gmail.com> <alpine.DEB.2.10.1410212037070.32297@blackhole.kfki.hu>
 <CAC=w+U7h2njKOB74XwP-C-Y37kcTDLKw2vGCUuK+afzCueqpQg@mail.gmail.com> <alpine.DEB.2.10.1410212228290.741@blackhole.kfki.hu> <alpine.DEB.2.10.1410212248510.938@blackhole.kfki.hu> <CAC=w+U6j+V6zLvdVBQKYjBSRq6YXshLPzXyg3G-NYZvk23CCEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: vDev <vijaypas@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:35234 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbaJVThS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:37:18 -0400
In-Reply-To: <CAC=w+U6j+V6zLvdVBQKYjBSRq6YXshLPzXyg3G-NYZvk23CCEQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 21 Oct 2014, vDev wrote:

> I am unable to post a pcap file at this point but here is an ASCII
> output. The last ACK (ID: 6200) was considered invalid due to III
> evaluating to 0 and res=0 in the earlier trace.

That cannot be the last ACK, because it's a FIN, ACK packet:

>     Linux_Router.1026 > REMOTE_SERVER.63001: Flags [F.], cksum 0xf632
> (correct), seq 31, ack 20, win 1500, length 0
> 16:39:35.328857 IP (tos 0x0, ttl 52, id 6200, offset 0, flags [DF],
> proto TCP (6), length 40)

However, this is still not enough. The debug lines corresponding to the 
captured packets are required too. Moreover, previously there were packets 
skipping the window checking in the debug log, without enough debug data 
to identify them:

> <7>[ 2238.870000] tcp_conntracks:
> <7>[ 2238.870000] syn=0 ack=1 fin=0 rst=0 old=3 new=3
> <7>[ 2238.870000] tcp_conntracks:
> <7>[ 2238.870000] syn=0 ack=1 fin=1 rst=0 old=3 new=4

So please apply this small patch, which adds the missing debug info:

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 44d1ea3..655170f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -830,12 +830,16 @@ static int tcp_packet(struct nf_conn *ct,
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
 
+	pr_debug("tcp_packet: ");
 	spin_lock_bh(&ct->lock);
 	old_state = ct->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
 	tuple = &ct->tuplehash[dir].tuple;
+	pr_debug("dir=%u, seq=%u ack=%u win=%u end=%u\n",
+		 dir, ntohl(th->seq), ntohl(th->ack_seq), ntohs(th->window),
+		 segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th));
 
 	switch (new_state) {
 	case TCP_CONNTRACK_SYN_SENT:


and send me the kernel debug messages and the tcpdump recording of the 
packet flow. If you must send the tcpdump in ascii, then print absolute 
and not relative TCP sequence numbers.

At the moment the only thing I see about the packet flow is that the first 
reply packet answering the first FIN does not ack the FIN flag itself. 
However the TCP conntrack state table advances the state to CLOSE_WAIT, 
instead of keeping the FIN_WAIT state. But that's still not a problem 
in handling the next packets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
