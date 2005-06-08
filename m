From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 08 Jun 2005 10:23:53 +0200
Message-ID: <42A6AB19.2040106@tac.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42A625DA.7090807@eurodev.net>
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

Hey Pablo,

> You've killed the new version of ip_ct_gather_frags available in 2.4.31:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/raw/linux-2.4.patch?rev=3692&view=markup

> -    /* Gather fragments. */
> -    if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
> -        *pskb = ip_ct_gather_frags(*pskb,
> -                                   hooknum == NF_IP_PRE_ROUTING ?
> -                                   IP_DEFRAG_CONNTRACK_IN :
> -                                   IP_DEFRAG_CONNTRACK_OUT);
> -        if (!*pskb)
> -            return NF_STOLEN;
> -    }
> 
> but you've replaced it with the old one, that goes in ip_conntrack_defrag:
> 
> +    /* Gather fragments. */
> +    if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
> +        *pskb = ip_ct_gather_frags(*pskb);
> +        if (!*pskb)
> +            return NF_STOLEN;
> +    }

The patch in POM then is kind of misleading.

>> ip_conntrack_standalone.c: At top level:
>> ip_conntrack_standalone.c:546: `ip_conntrack_untracked' undeclared
>> here (not ina
>> function)
> 
> 
> The hunk attached below is missing in your patch. You need to declare
> ip_conntrack_untracked as extern in ip_conntrack.h.

I figured something like that but why has it changed and which one is correct
now with respect to 2.4.31?

> -------- missing hunk ----------------
> diff -urN --exclude-from=/usr/src/diff.exclude
> linux-2.4.22-log/include/linux/netfilter_ipv4/ip_conntrack.h
> linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_conntrack.h
> --- linux-2.4.22-log/include/linux/netfilter_ipv4/ip_conntrack.h
> 2003-09-17 17:14:54.000000000 +0200
> +++ linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_conntrack.h
> 2003-09-28 14:22:09.000000000 +0200
> @@ -250,6 +250,9 @@
>  /* Call me when a conntrack is destroyed. */
>  extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
> 
> +/* Fake conntrack entry for untracked connections */
> +extern struct ip_conntrack ip_conntrack_untracked;
> +
>  extern int ip_ct_no_defrag;
>  /* Returns new sk_buff, or NULL */
>  struct sk_buff *
>  ip_ct_gather_frags(struct sk_buff *skb);
> ------- end of missing hunk ---------------

Thanks, I'll try that.

> Those will fix compilation. No big changes has gone into 2.4/netfilter
> since quite some time, anyway I would need to check this more in deep to
> make sure that everything works like a charm. Re-post a new patch and
> I'll have a look at it again.

I'll see if I can give it a spin. Unfortunately the POM mechanism (mainly the
malfunctioning runme tool) makes it very hard for us here to extract patches.

I need to know how it should be done correctly though. I'm a bit opposed to
ripping out the fragment below from the kernel:

> -    if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
> -        *pskb = ip_ct_gather_frags(*pskb,
> -                                   hooknum == NF_IP_PRE_ROUTING ?
> -                                   IP_DEFRAG_CONNTRACK_IN :
> -                                   IP_DEFRAG_CONNTRACK_OUT);
> -        if (!*pskb)
> -            return NF_STOLEN;
> -    }

I my opinion the part above should stay and the POM patch adapted.

Thank you very much for your help. BTW, I haven't forgotten about the nfnetlink
backport thing, it's just stalled here internally due to different priorities.

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
