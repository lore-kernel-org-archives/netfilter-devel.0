From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH-2.4-POM] NF_REPEAT was ignored !
Date: Fri, 24 Oct 2003 00:02:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310232349181.20545-100000@blackhole.kfki.hu>
References: <20031022102556.GA10540@alpha.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20031022102556.GA10540@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

On Wed, 22 Oct 2003, Willy Tarreau wrote:

> I captured lots of data (/p/n/ip_conntrack, logs, tcpdump) and discovered
> another problem with tcp_window_tracking that I could easily reproduce on
> a lab : if a client reused a port too early, then the SYN/ACK from the
> server was dropped, and the client could only connect after the next SYN
> retransmit. I simply checked it with nc -p 1234 server 80. The first one
> succeeds immediately, the second one needs 3 seconds to establish. There
> is a logical explication to this :

[...]

> The problem is that once ip_conntrack_in() is called again with the same pskb,
> it already has its ->nfct filled, so ip_conntrack_in() immediately returns
> NF_ACCEPT without doing any lookup. The result is that the SYN is passed to
> the server, and the deleted session is not recreated. When the server replies
> with a SYN/ACK, this one has no matching session it is blocked by the firewall
> rules. Then, 3 seconds later, the client retransmits its SYN, which reaches
> the firewall without any matching session, and correctly initiates a new one.
>
> The solution is to correctly clear the ->nfct field in ip_conntrack_in() if
> we return NF_REPEAT. This is what the following patch does. It's to be applied
> to 2.4+POM-20030912, but I'm confident it may be easily applied and/or ported
> to later versions.

Well spotted problem and the fix is correct. But I'd better apply
a sligthly modified version which does not add one more condition to the
conntrack core:

--- linux/net/ipv4/netfilter/ip_conntrack_core.c.orig	2003-10-23 23:43:20.000000000  +0200
+++ linux/net/ipv4/netfilter/ip_conntrack_core.c	2003-10-23 23:46:03.000000000  +0200
@@ -838,11 +838,12 @@
 	IP_NF_ASSERT((*pskb)->nfct);

 	ret = proto->packet(ct, *pskb, ctinfo);
-	if (ret == -1) {
-		/* Invalid */
+	if (ret < 0 ) {
+		/* Invalid: inverse of the return code tells
+		   to netfilter core what to do. */
		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		return NF_ACCEPT;
+		return -ret;
 	}

 	if (ret != NF_DROP && ct->helper) {

with the slight modification of the TCP window tracking code by returning
-NF_REPEAT instead of NF_REPEAT.

> I've not checked yet if the mainline conntrack code is also affected, but this
> could be possible.

No, that does not handle reopening at all.

Thank you your valuable reports!

Best regards,
Jozsef

-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
