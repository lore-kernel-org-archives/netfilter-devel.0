From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Tue, 15 Jun 2004 21:06:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406152051120.17507-100000@blackhole.kfki.hu>
References: <40CF40B3.7040109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40CF40B3.7040109@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Tue, 15 Jun 2004, Patrick McHardy wrote:

> > I committed the fixed version of the patch in cvs. Besides the fix the
> > talkative log messages were trimmed in order to fit (better) into the
> > ULOG buffer.
>
> I think there is still a problem.
>
> +       if (csum_tcpudp_magic(iph->saddr, iph->daddr,
> +                             tcplen, IPPROTO_TCP,
> +                             skb->ip_summed == CHECKSUM_HW
> +                             && hooknum == NF_IP_PRE_ROUTING
> +                               ? skb->csum
> +                               : skb_checksum(skb, iph->ihl*4, tcplen,
> 0))) {
>
> On the outgoing path, the NIC is supposed to checksum the packet when
> CHECKSUM_HW is set, so it hasn't got a valid checksum when the check
> is performed.  Do we need to check the checksum in LOCAL_OUT at all ?
> Other than from raw-sockets, invalid packets can not occur.

Finally, finally I see. Then we have to get rid of the checksum checking
on the outgoing path, indeed:

+       if (hooknum == NF_IP_PRE_ROUTING
+	    && csum_tcpudp_magic(iph->saddr, iph->daddr,
+                                tcplen, IPPROTO_TCP,
+                                skb->ip_summed == CHECKSUM_HW
+                                  ? skb->csum
+                                  : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
