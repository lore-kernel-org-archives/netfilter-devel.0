From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 14 Jun 2004 16:03:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>
References: <40CD8E0A.6050900@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40CD8E0A.6050900@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 14 Jun 2004, Pablo Neira wrote:

> >+       /* It may be an special packet, error, unclean... */
> >+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)) != NF_ACCEPT)
> >+               return ret;
>
> I'm still in doubt, if we found an unclean packet, we should return
> NF_ACCEPT, so we let the packet continues its travel. In that case, the
> skbuff  won't have a conntrack associated and the sysadmin could
> explicitely drop invalid packets with an iptables rule, am I right?

As I sent my mail I noticed that I'm mistaken: following what I suggested
the goal to encapsulate the ICMP error message handling could not be done.

So the semantics could follow the one applied in the tcp-window-tracking
patch: stop the processing of the packet by returning negated error code;
otherwise continue:

+       /* It may be an special packet, error, unclean...
+        * inverse of the return code tells to the netfilter
+	 * core what to do with the packet. */
+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0)
+               return -ret;

That way we can draw any shortcut decision in the error function and
NF_ACCEPT means just to traverse further in conntrack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
