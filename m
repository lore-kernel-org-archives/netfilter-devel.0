From: linux lover <linux.lover2004@gmail.com>
Subject: Re: printing packet data
Date: Thu, 23 Dec 2004 08:19:28 +0530
Message-ID: <72c6e37904122218495cb49348@mail.gmail.com>
References: <72c6e37904122118504466dd28@mail.gmail.com>
Reply-To: linux lover <linux.lover2004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <kernelnewbies-bounce@nl.linux.org>
To: kernelnewbies@nl.linux.org
In-Reply-To: <72c6e37904122118504466dd28@mail.gmail.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: netfilter-devel.vger.kernel.org

Hello Lukas,
            As you said i  use following printk with for loop and
included at hook_func1.
 for (i=0;i<5;i++)
    printk(KERN_DEBUG"Packet data is %02x\t",sb->data[i]);
But i am not getting any output in /var/log/messages. Where am i
wrong? I specified to print only 5 chars at start to check whether i
can get packet dump or not?
         What else should i include in module code i posted already
with above lines?
regards,
linux.lover

On Wed, 22 Dec 2004 08:20:42 +0530, linux lover
<linux.lover2004@gmail.com> wrote:
> Hi all,
> I want to print skb->data contents in kernel module using netfilter module at
> NF_HOOK NF_IP_LOCAL_OUT. How can i do that? I know how to write netfilter
> module like this one
> #define MODULE
> #define __KERNEL__
> 
>           #include <linux/module.h>
>           #include <linux/kernel.h>
>           #include <linux/skbuff.h>
>           #include <linux/ip.h>
>           #include <linux/netfilter.h>
>           #include <linux/netfilter_ipv4.h>
> 
>           static struct nf_hook_ops nfho1;
>           static unsigned char *packet_ip = "\x7f\x00\x00\x0b";
> 
>           unsigned int hook_func1(unsigned int hooknum,struct sk_buff **skb,
>                                  const struct net_device *in,
>                                  const struct net_device *out,
>                                  int (*okfn)(struct sk_buff *))
>           {
>               struct sk_buff *sb = *skb;
>               printk(KERN_DEBUG "calling hook_func at NF_IP_LOCAL_OUT\n");
>                 if (sb->nh.iph->saddr == *(unsigned int *)packet_ip)
>                  {
>  /*CODE REQUIRE TO BE INCLUDED HERE*/
>                   return NF_ACCEPT;
>           }
>                else
>                     return NF_ACCEPT;
> 
>           }
> 
> static int __init init(void)
>   {
>               nfho1.hook     = hook_func1;
>               nfho1.hooknum  = NF_IP_LOCAL_OUT;
>               nfho1.pf       = PF_INET;
>               nfho1.priority = NF_IP_PRI_FIRST;
>               nf_register_hook(&nfho1);
>               return 0;
>           }
> 
> static void __exit fini(void)
>           {
>               nf_unregister_hook(&nfho1);
>           }
> module_init(init);
> module_exit(fini);
> MODULE_LICENSE("GPL");
> 
> But how can i print those HEX codes in packet?
> regards,
> linux.lover
>

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/
