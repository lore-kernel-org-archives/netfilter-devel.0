From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: What can i do ? When i rmmod the modules .
Date: Fri, 9 May 2003 15:42:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305091536320.9035-100000@blackhole.kfki.hu>
References: <002f01c3162d$45b49db0$01e7a8c0@zpeak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: cyberyam <zpeak@cyberyam.com>
In-Reply-To: <002f01c3162d$45b49db0$01e7a8c0@zpeak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 9 May 2003, cyberyam wrote:

Just scanning, there might be other bugs as well:

> static unsigned int myfirewall(unsigned int hooknum,struct sk_buff **skb,
>   const struct net_device *in,
>   const struct net_device *out,int (*okfn)(struct sk_buff*))
> {
>  struct sk_buff *newskb ;
>  int len ;
>  len = (*skb)->truesize ;
>
>  newskb = alloc_skb(len,GFP_ATOMIC);
>  if(!newskb) {
>   printk("can't alloc whole buffer \n");
>  }

You continue to work even when the system could not allocate the memory,
and then try to copy to the nonexistent space:

>  newskb = skb_copy(*skb,GFP_ATOMIC);
>
>  netlink_broadcast(nfmylog,skb,0 , 1,GFP_ATOMIC) ;
>  kfree_skb(newskb) ;
>
>  return NF_ACCEPT;
> }
>
> static struct nf_hook_ops iplimitfilter=
> {
>  {NULL,NULL},
>  myfirewall,
>  PF_INET,
>  NF_IP_PRE_ROUTING,
>  NF_IP_PRI_FILTER
> };
>
> int  init_module(void)
> {
>  nfmylog = netlink_kernel_create(NETLINK_MYLOG,NULL);

You does not check wether you could create the netlink.
NULL is not a protocol indentifier.

>  return nf_register_hook(&iplimitfilter);
> }
>
> static  void  cleanup_module(void)
> {
>  nf_unregister_hook(&iplimitfilter);
>  sock_release(nfmylog->socket);
> }

sock_release is not appropriare to release a netlink.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
