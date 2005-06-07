From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 08 Jun 2005 00:55:22 +0200
Message-ID: <42A625DA.7090807@eurodev.net>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42A5B144.3090005@tac.ch>
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

Hi Roberto,

Roberto Nibali wrote:
>>This is the updated (rediffed) patch against 2.4.31 for the raw table feature.
>>So far this has not been compile tested. Chunk #1 and #3 of the
>>ip_conntrack_core.c part failed.
> 
> 
> To avoid confusion: that was the reason I sent this patch. However when
> compiling I get following error:
> 
> gcc -D__KERNEL__
> -I/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/include -Wall
> -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common
> -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i686  -DMODULE
> -DMODVERSIONS -include
> /home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/include/linux/modversions.h
>  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_conntrack_standalone
> -DEXPORT_SYMTAB -c ip_conntrack_standalone.c
> ip_conntrack_standalone.c: In function `ip_conntrack_defrag':
> ip_conntrack_standalone.c:205: too few arguments to function
> `ip_ct_gather_frags_Rsmp_0ed3e638'


You've killed the new version of ip_ct_gather_frags available in 2.4.31:

-	/* Gather fragments. */
-	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb = ip_ct_gather_frags(*pskb,
-		                           hooknum == NF_IP_PRE_ROUTING ?
-		                           IP_DEFRAG_CONNTRACK_IN :
-		                           IP_DEFRAG_CONNTRACK_OUT);
-		if (!*pskb)
-			return NF_STOLEN;
-	}

but you've replaced it with the old one, that goes in ip_conntrack_defrag:

+	/* Gather fragments. */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
+		*pskb = ip_ct_gather_frags(*pskb);
+		if (!*pskb)
+			return NF_STOLEN;
+	}

> ip_conntrack_standalone.c: At top level:
> ip_conntrack_standalone.c:546: `ip_conntrack_untracked' undeclared here (not ina
> function)

The hunk attached below is missing in your patch. You need to declare 
ip_conntrack_untracked as extern in ip_conntrack.h.

-------- missing hunk ----------------
diff -urN --exclude-from=/usr/src/diff.exclude 
linux-2.4.22-log/include/linux/netfilter_ipv4/ip_conntrack.h 
linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.22-log/include/linux/netfilter_ipv4/ip_conntrack.h 
2003-09-17 17:14:54.000000000 +0200
+++ linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_conntrack.h 
2003-09-28 14:22:09.000000000 +0200
@@ -250,6 +250,9 @@
  /* Call me when a conntrack is destroyed. */
  extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);

+/* Fake conntrack entry for untracked connections */
+extern struct ip_conntrack ip_conntrack_untracked;
+
  extern int ip_ct_no_defrag;
  /* Returns new sk_buff, or NULL */
  struct sk_buff *
  ip_ct_gather_frags(struct sk_buff *skb);
------- end of missing hunk ---------------

Those will fix compilation. No big changes has gone into 2.4/netfilter 
since quite some time, anyway I would need to check this more in deep to 
make sure that everything works like a charm. Re-post a new patch and 
I'll have a look at it again.

--
Pablo
