From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: 2.6.6-rc3 - "ip_conntrack_in: Frag of proto 17" (udp) with kNFS
 r/wsize > 8192
Date: Fri, 7 May 2004 12:30:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405071226130.13178@tux.rsn.bth.se>
References: <200405070411.48918.keaafloy@online.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kenneth =?iso-8859-1?q?Aafl=F8y?= <keaafloy@online.no>
In-Reply-To: <200405070411.48918.keaafloy@online.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 7 May 2004, Kenneth Aafl=F8y wrote:

> Hi!
>
> I hope this problem has not been reported before or that I'm not just pic=
king
> up on some user-keyboard troubles, I've read over the archives, but could=
 not
> find anything relevat to this issue.
>
> I've come across some strange behavior with a nfs server running on 2.6.6=
-rc3
> today. My clients is also running this version. Basically when I set the =
NFS
> client r/wsize =3D 8192, or remove the connection tracking netfilter modu=
les
> the problem goes away. If I set the r/wsize to 16834 and the conntrack mo=
dule
> is loaded I end up in the code segment below. When this happens the NFS
> client will almost lose connection with the server, and print a lot of;
> NFS server not responding, still trying. NFS server OK.
>
> I've also tried 2.6.5, and the error is present there too, but not the se=
gment
> below, so I got no warning. I have not yet tried any lower version of the
> kernel yet, but will do so if it's requested. I could also have provided =
you
> with extensive information about my setup's, but I belive it's a minor
> problem with the reassembly of fragmented packets.
>
> ip_conntrack_core.c:798
>     /* Never happen */
>     if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
>         if (net_ratelimit()) {
>         printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=3D%u)\n"=
,
>                (*pskb)->nh.iph->protocol, hooknum);
>         }
>         return NF_DROP;
>     }
>
> Does anybody have a solution for the problem exept making (manually) sure=
 that
> any client does not request a r/wsize above 8192?

Could you test this patch? If it triggers we know that we still have
fragmented packets after defrag, which we shouldn't.

--- linux-2.6.6-rc3/net/ipv4/netfilter/ip_conntrack_standalone.c.orig=09200=
4-05-07 12:22:36.000000000 +0200
+++ linux-2.6.6-rc3/net/ipv4/netfilter/ip_conntrack_standalone.c=092004-05-=
07 12:24:37.000000000 +0200
@@ -211,6 +211,10 @@
 =09=09if (!*pskb)
 =09=09=09return NF_STOLEN;
 =09}
+
+=09if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET))
+=09=09printk(KERN_ERR "ip_conntrack_defrag: packet still fragmented after =
defrag!\n");
+
 =09return NF_ACCEPT;
 }

/Martin
