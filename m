From: Svenning Sorensen <sss@sss.dnsalias.net>
Subject: Re: [patch] tcp connection tracking 2.4.19
Date: Thu, 17 Oct 2002 10:26:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.2.20021017101600.00bc4328@sss.dnsalias.net>
References: <20021016074837.GA18011@old.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Renold <martinxyz@gmx.ch>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20021016074837.GA18011@old.homeip.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

At 09:48 16-10-2002, Martin Renold wrote:
>So I wrote a simple patch against 2.4.19, but I must admit that I do not
>really understand the code around it, especially why it does not mark
>such a packet as invalid (I'm new to most things here). It's running
>right now on 3-4 machines.

I can't speak about the merits of this patch, since I haven't tried it, but
I believe there is a bug in it:

>--- kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c     Fri Oct  4 08:13:38 2002
>+++ kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c      Sat Oct  5 20:45:49 2002
>@@ -180,6 +180,8 @@
>        if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
>            && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
>            && tcph->syn && tcph->ack)
>+               conntrack->proto.tcp.handshake_seq
>+                       = tcph->ack_seq;
>                conntrack->proto.tcp.handshake_ack
>                        = htonl(ntohl(tcph->seq) + 1);
>        WRITE_UNLOCK(&tcp_lock);
>-- 


Note that the original statement will now be unconditionally executed.
You need to enclose the statements by brackets.


Svenning
