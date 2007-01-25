From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: owner-Match in 2.6.20-rc5 (fwd)
Date: Thu, 25 Jan 2007 21:31:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701252121190.26664@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="=-UzeIImtjt/uAk/xeVi/I"
Cc: netfilter-devel@lists.netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-ID: <Pine.LNX.4.64.0701252121191.26664@blackhole.kfki.hu>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--=-UzeIImtjt/uAk/xeVi/I
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0701252121192.26664@blackhole.kfki.hu>

Hi,

The report below was posted on the netfilter user list. Isn't there any=20
ill side effect by reverting the change?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary

---------- Forwarded message ----------
Date: Thu, 25 Jan 2007 20:16:17 +0100
From: Sebastian <netfilter@basti79.de>
To: netfilter@lists.netfilter.org
Subject: Re: owner-Match in 2.6.20-rc5

Am Donnerstag, den 25.01.2007, 10:23 +0100 schrieb Sebastian Cla=DFen:
> Hi...
>
> Kernel:   2.6.20-rc5
> Iptables: v1.3.7-20070118
>
> The owner-Match seems not to match TCP-Packets any more. Can be tested
> by inserting the rule:
> iptables -I OUTPUT -m owner --uid-owner test-user -j LOG
>
> Simply su to the specified user and using netcat (nc) to send UDP and
> TCP packets shows only log entried with PROTO=3DUDP but none with TCP.
>
> Anyone can reproduce this and pearhaps got a solution??
>
> Greets
>   Sebastian.
>

Hi again...

I've just found out where the problem is. In 2.6.20-rc1 changelog the
following thing was modified:
[TCP]: Don't set SKB owner in tcp_transmit_skb().

That seems to break the owner-match for TCP packets. I was able to undo
the change with the attached one-line patch which fixed the problem for
me.

Greets
   Sebastian.
--=-UzeIImtjt/uAk/xeVi/I
Content-Type: TEXT/X-PATCH; NAME=owner-fix.diff; CHARSET=us-ascii
Content-ID: <Pine.LNX.4.64.0701252121193.26664@blackhole.kfki.hu>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=owner-fix.diff

--- linux-2.6.20-rc5.orig/net/ipv4/tcp_output.c	2007-01-25 20:10:04.000000000 +0100
+++ linux-2.6.20-rc5/net/ipv4/tcp_output.c	2007-01-25 14:43:48.000000000 +0100
@@ -467,6 +467,7 @@ static int tcp_transmit_skb(struct sock 
 
 	th = (struct tcphdr *) skb_push(skb, tcp_header_size);
 	skb->h.th = th;
+	skb_set_owner_w(skb, sk);
 
 	/* Build TCP header and checksum it. */
 	th->source		= inet->sport;

--=-UzeIImtjt/uAk/xeVi/I--
