From: Piotr Duszynski <regis44@gmail.com>
Subject: Re: [PATCH 1/1 ] Conntrack extensions : Interrupt timeout
Date: Mon, 22 Dec 2008 11:46:10 +0100
Message-ID: <494F6FF2.1010502@gmail.com>
References: <49467ACC.8080107@trash.net>	 <20081216.012018.196068498.davem@davemloft.net>	 <49495F88.2010103@gmail.com>	 <38bcb3ec0812171836r4c6161b2m1026d73722a72cfe@mail.gmail.com>	 <494D4A11.5080304@gmail.com> <38bcb3ec0812220107y64c4f495s1e37adb0169741ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:48073 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYLVKvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:51:10 -0500
Received: by fg-out-1718.google.com with SMTP id 19so756931fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Dec 2008 02:51:08 -0800 (PST)
In-Reply-To: <38bcb3ec0812220107y64c4f495s1e37adb0169741ec@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, my mistake .

One interesting thing about this issue is that it might be realted to
vmware clock issues, since sometimes I am getting the 'clocksource tsc
unstable' with huge delta in ns . I have tried booting my new kernel
with noapic and the result is that it hangs even faster . Today I will
try to check this on a normal PC and see if this is the case

Piotrek

James King wrote:
> Please don't drop the mailing list CC when replying.  There are people
> here much more talented than myself that might be able to help.
> 
> On Sat, Dec 20, 2008 at 11:40 AM, Piotr Duszynski <regis44@gmail.com> wrote:
>> Dear James,
>>
>> I have rewritten my code according to your advice. Unfortunately I am
>> still getting the same exception ( death_by_timeout () ) at random
>> moments ( Sometimes this occurs after creating many conntracks with nc
>> www.google.com . Another time instantly after first tcp connection has
>> been made . I would be very grateful If you could point me the direction
>> in which I could investigate this problem .
>>
>> I don't know if this has anything to do, but I am testing this patch on
>> VMware Fedora 10 wit selinux enabled .
>>
>> Best regards
>> Piotr Duszynski
>>
>> I have attached new patch to this e-mail :
>>
>> diff -uNr
>> linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
>> linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
>> ---
>> linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
>> 2008-11-28 07:31:14.000000000 +0100
>> +++ linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
>> 2008-12-09 17:42:47.000000000 +0100
>> @@ -73,6 +73,10 @@
>>        /* Connection has fixed timeout. */
>>        IPS_FIXED_TIMEOUT_BIT = 10,
>>        IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
>> +
>> +       /* Connection has src L2 info */
>> +       IPS_L2_INFO_BIT = 11,
>> +       IPS_L2_INFO = (1 << IPS_L2_INFO_BIT),
>>  };
>>
>>  /* Connection tracking event bits */
>> diff -uNr
>> linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
>> linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
>> --- linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
>> 2008-11-28 07:31:53.000000000 +0100
>> +++ linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
>> 2008-12-14 04:16:44.000000000 +0100
>> @@ -8,12 +8,14 @@
>>        NF_CT_EXT_HELPER,
>>        NF_CT_EXT_NAT,
>>        NF_CT_EXT_ACCT,
>> +       NF_CT_EXT_L2INFO,
>>        NF_CT_EXT_NUM,
>>  };
>>
>>  #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
>>  #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
>>  #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
>> +#define NF_CT_EXT_L2INFO_TYPE struct nf_conn_l2info
>>
>>  /* Extensions: optional stuff which isn't permanently in struct. */
>>  struct nf_ct_ext {
>> diff -uNr
>> linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_l2info.h
>> linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_l2info.h
>> --- linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_l2info.h
>> 1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_l2info.h
>> 2008-12-19 06:58:47.000000000 +0100
>> @@ -0,0 +1,39 @@
>> +#ifndef _NF_CONNTRACK_L2INFO_H
>> +#define _NF_CONNTRACK_L2INFO_H
>> +
>> +#include <linux/if_ether.h>
>> +#include <linux/netfilter/nf_conntrack_tuple_common.h>
>> +#include <net/netfilter/nf_conntrack_extend.h>
>> +
>> +struct nf_conn_l2info {
>> +       // MAC only at the moment
>> +       unsigned char src_addr[ETH_ALEN];
>> +       unsigned char dst_addr[ETH_ALEN];
>> +};
>> +
>> +
>> +static inline
>> +struct nf_conn_l2info  *nfct_l2info(const struct nf_conn *ct)
>> +{
>> +        return nf_ct_ext_find(ct,NF_CT_EXT_L2INFO);
>> +}
>> +
>> +
>> +static inline
>> +struct nf_conn_l2info *nf_ct_l2info_ext_add(struct nf_conn *ct, gfp_t gfp)
>> +{
>> +       struct nf_conn_l2info *l2info;
>> +
>> +       l2info = nf_ct_ext_add(ct, NF_CT_EXT_L2INFO,GFP_ATOMIC);
>> +        if (l2info == NULL) {
>> +                            printk(KERN_INFO "failed to add L2INFO
>> extension\n");
>> +                            }
>> +
>> +       return l2info;
>> +};
>> +
>> +extern int nf_conntrack_l2info_init(void);
>> +extern void nf_conntrack_l2info_fini(void);
>> +
>> +
>> +#endif
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/Kconfig
>> linux-2.6.27.i686.new/net/netfilter/Kconfig
>> --- linux-2.6.27.i686.orig/net/netfilter/Kconfig        2008-11-28
>> 07:29:39.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/Kconfig 2008-12-09
>> 18:52:13.000000000 +0100
>> @@ -380,6 +380,16 @@
>>
>>          To compile it as a module, choose M here.  If unsure, say N.
>>
>> +
>> +config NETFILTER_XT_TARGET_L2INFO
>> +       tristate  '"L2INFO" target support'
>> +       depends on NETFILTER_XTABLES
>> +       depends on NF_CONNTRACK
>> +       help
>> +         Adds L2 info to the connection
>> +         If unsure, say `N'.
>> +
>> +
>>  config NETFILTER_XT_TARGET_NOTRACK
>>        tristate  '"NOTRACK" target support'
>>        depends on NETFILTER_XTABLES
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/Makefile
>> linux-2.6.27.i686.new/net/netfilter/Makefile
>> --- linux-2.6.27.i686.orig/net/netfilter/Makefile       2008-11-28
>> 07:29:33.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/Makefile        2008-12-19
>> 20:35:01.000000000 +0100
>> @@ -1,6 +1,6 @@
>>  netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
>>
>> -nf_conntrack-y := nf_conntrack_core.o nf_conntrack_standalone.o
>> nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o
>> nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o
>> nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
>> nf_conntrack_acct.o
>> +nf_conntrack-y := nf_conntrack_core.o nf_conntrack_standalone.o
>> nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o
>> nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o
>> nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
>> nf_conntrack_acct.o nf_conntrack_l2info.o
>>  nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
>>
>>  obj-$(CONFIG_NETFILTER) = netfilter.o
>> @@ -49,6 +49,7 @@
>>  obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
>>  obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
>>  obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
>> +obj-$(CONFIG_NETFILTER_XT_TARGET_L2INFO) += xt_L2INFO.o
>>  obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
>>  obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
>>
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_core.c
>> linux-2.6.27.i686.new/net/netfilter/nf_conntrack_core.c
>> --- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_core.c    2008-11-28
>> 07:29:33.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_core.c     2008-12-19
>> 06:55:31.000000000 +0100
>> @@ -38,6 +38,7 @@
>>  #include <net/netfilter/nf_conntrack_core.h>
>>  #include <net/netfilter/nf_conntrack_extend.h>
>>  #include <net/netfilter/nf_conntrack_acct.h>
>> +#include <net/netfilter/nf_conntrack_l2info.h>
>>
>>  #define NF_CONNTRACK_VERSION   "0.5.0"
>>
>> @@ -557,6 +558,7 @@
>>        }
>>
>>        nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>> +       nf_ct_l2info_ext_add(ct, GFP_ATOMIC);
>>
>>        spin_lock_bh(&nf_conntrack_lock);
>>        exp = nf_ct_find_expectation(tuple);
>> @@ -1032,6 +1034,8 @@
>>        nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
>>                             nf_conntrack_htable_size);
>>
>> +
>> +       nf_conntrack_l2info_fini();
>>        nf_conntrack_acct_fini();
>>        nf_conntrack_expect_fini();
>>        nf_conntrack_helper_fini();
>> @@ -1178,6 +1182,11 @@
>>        ret = nf_conntrack_acct_init();
>>        if (ret < 0)
>>                goto out_fini_helper;
>> +
>> +       ret = nf_conntrack_l2info_init();
>> +       if (ret < 0)
>> +               goto out_fini_helper;
>> +
>>
>>        /* For use by REJECT target */
>>        rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_l2info.c
>> linux-2.6.27.i686.new/net/netfilter/nf_conntrack_l2info.c
>> --- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_l2info.c
>> 1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_l2info.c   2008-12-19
>> 23:37:04.000000000 +0100
>> @@ -0,0 +1,33 @@
>> +#include <linux/netfilter.h>
>> +#include <linux/kernel.h>
>> +#include <linux/moduleparam.h>
>> +#include <net/netfilter/nf_conntrack.h>
>> +#include <net/netfilter/nf_conntrack_extend.h>
>> +#include <net/netfilter/nf_conntrack_l2info.h>
>> +
>> +MODULE_PARM_DESC(acct, "Enable l2info tracking.");
>> +
>> +static struct nf_ct_ext_type l2info_extend __read_mostly = {
>> +       .len            = sizeof(struct nf_conn_l2info),
>> +       .align          = __alignof__(struct nf_conn_l2info),
>> +       .id             = NF_CT_EXT_L2INFO,
>> +};
>> +
>> +int nf_conntrack_l2info_init(void)
>> +{
>> +
>> +       int ret;
>> +
>> +       ret = nf_ct_extend_register(&l2info_extend);
>> +       if (ret < 0) {
>> +               printk(KERN_ERR "Unable to register L2INFO extension\n");
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +void nf_conntrack_l2info_fini(void)
>> +{
>> +       nf_ct_extend_unregister(&l2info_extend);
>> +}
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.c
>> linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
>> --- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.c
>> 2008-11-28 07:29:39.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
>> 2008-12-19 07:27:41.000000000 +0100
>> @@ -26,6 +26,8 @@
>>  #include <net/netfilter/nf_conntrack_expect.h>
>>  #include <net/netfilter/nf_conntrack_helper.h>
>>  #include <net/netfilter/nf_conntrack_acct.h>
>> +#include <net/netfilter/nf_conntrack_l2info.h>
>> +
>>
>>  MODULE_LICENSE("GPL");
>>
>> @@ -151,6 +153,32 @@
>>        if (test_bit(IPS_ASSURED_BIT, &ct->status))
>>                if (seq_printf(s, "[ASSURED] "))
>>                        return -ENOSPC;
>> +       if (test_bit(IPS_L2_INFO, &ct->status))
>> +           {
>> +               if (seq_printf(s, "[L2INFO] "))
>> +                       return -ENOSPC;
>> +               struct nf_conn_l2info* l2info = nfct_l2info(ct);
>> +
>> +               if (!l2info)
>> +                       return -ENOSPC;
>> +
>> +               int
>> ret=seq_printf(s,"[%.2x:%.2x:%.2x:%.2x:%.2x:%.2x]<->[%.2x:%.2x:%.2x:%.2x:%.2x:%.2x]
>> ",
>> +                l2info->src_addr[0],
>> +                l2info->src_addr[1],
>> +                l2info->src_addr[2],
>> +                l2info->src_addr[3],
>> +                l2info->src_addr[4],
>> +                l2info->dst_addr[5],
>> +                l2info->dst_addr[0],
>> +                l2info->dst_addr[1],
>> +                l2info->dst_addr[2],
>> +                l2info->dst_addr[3],
>> +                l2info->dst_addr[4],
>> +                l2info->dst_addr[5]);
>> +
>> +               if (ret)
>> +               return -ENOSPC;
>> +           }
>>
>>  #if defined(CONFIG_NF_CONNTRACK_MARK)
>>        if (seq_printf(s, "mark=%u ", ct->mark))
>> diff -uNr linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c
>> linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c
>> --- linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c    1970-01-01
>> 01:00:00.000000000 +0100
>> +++ linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c     2008-12-19
>> 06:54:02.000000000 +0100
>> @@ -0,0 +1,113 @@
>> +#include <linux/skbuff.h>
>> +#include <linux/netfilter/x_tables.h>
>> +#include <net/netfilter/nf_conntrack.h>
>> +#include <linux/ip.h>
>> +#include <net/checksum.h>
>> +#include <net/netfilter/nf_conntrack_l2info.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/netfilter.h>
>> +#include <linux/netfilter_ipv4.h>
>> +#include <linux/inet.h>
>> +#include <linux/version.h>
>> +
>> +
>> +MODULE_AUTHOR("Piotr Duszynski L2 info target");
>> +MODULE_DESCRIPTION("x_tables per-conntrack L2info target");
>> +MODULE_LICENSE("GPL");
>> +
>> +
>> +static unsigned int target(struct sk_buff *skb,
>> +       const struct net_device *in,
>> +       const struct net_device *out,
>> +       unsigned int hooknum,
>> +       const struct xt_target *target,
>> +       const void *targinfo)
>> +{
>> +       struct nf_conn_l2info *l2info ;
>> +       struct nf_conn *ct;
>> +       enum ip_conntrack_info ctinfo;
>> +       struct ethhdr *eth;
>> +
>> +       ct = nf_ct_get(skb, &ctinfo);
>> +
>> +       if (ct && (! test_bit(IPS_L2_INFO,&ct->status)))
>> +       {
>> +
>> +       if(IP_CT_ESTABLISHED!=ctinfo
>> +       && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
>> +       return XT_CONTINUE;
>> +
>> +       if (  IP_CT_ESTABLISHED==ctinfo)
>> +       printk(KERN_INFO "L2INFO ESTABLISHED\n");
>> +       if ( ctinfo == IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
>> +       printk(KERN_INFO "L2INFO REPLY ESTABLISHED\n");
>> +
>> +               l2info = nfct_l2info(ct);
>> +               if (!l2info) {
>> +                       printk(KERN_INFO "failed to find L2INFO extension\n");
>> +                       return XT_CONTINUE;
>> +                       }
>> +
>> +               eth = (struct ethhdr *)skb_mac_header(skb);
>> +               printk( KERN_INFO "L2INFO: [ %.2x:%.2x:%.2x:%.2x:%.2x:%.2x ->
>> %.2x:%.2x:%.2x:%.2x:%.2x:%.2x] \n",
>> +                 eth->h_source[0],
>> +                 eth->h_source[1],
>> +                 eth->h_source[2],
>> +                 eth->h_source[3],
>> +                 eth->h_source[4],
>> +                 eth->h_source[5],
>> +                 eth->h_dest[0],
>> +                 eth->h_dest[1],
>> +                 eth->h_dest[2],
>> +                 eth->h_dest[3],
>> +                 eth->h_dest[4],
>> +                 eth->h_dest[5]);
>> +
>> +               l2info->src_addr[0]=eth->h_source[0];
>> +                l2info->src_addr[1]=eth->h_source[1];
>> +                l2info->src_addr[2]=eth->h_source[2];
>> +                l2info->src_addr[3]=eth->h_source[3];
>> +                l2info->src_addr[4]=eth->h_source[4];
>> +                l2info->src_addr[5]=eth->h_source[5];
>> +                l2info->dst_addr[0]=eth->h_dest[0];
>> +                l2info->dst_addr[1]=eth->h_dest[1];
>> +                l2info->dst_addr[2]=eth->h_dest[2];
>> +                l2info->dst_addr[3]=eth->h_dest[3];
>> +                l2info->dst_addr[4]=eth->h_dest[4];
>> +                l2info->dst_addr[5]=eth->h_dest[5];
>> +
>> +               //memcpy(l2info->src_addr,eth->h_source,sizeof( unsigned char
>> )*ETH_ALEN );
>> +               //memcpy(l2info->src_addr,eth->h_dest,sizeof( unsigned char )*ETH_ALEN );
>> +               set_bit(IPS_L2_INFO,&ct->status);
>> +       }
>> +               return XT_CONTINUE;
>> +}
>> +
>> +
>> +static struct xt_target xt_l2info __read_mostly = {
>> +               .name           = "L2INFO",
>> +               .family         = AF_INET,
>> +               .target         = target,
>> +               .me             = THIS_MODULE,
>> +};
>> +
>> +static int __init xt_l2info_init(void)
>> +{
>> +       int ret;
>> +
>> +       ret = xt_register_target(&xt_l2info);
>> +       if (ret < 0)
>> +       printk(KERN_ERR "xt_L2INFO: Unable to register target \n");
>> +
>> +       return ret;
>> +}
>> +
>> +static void __exit xt_l2info_fin(void)
>> +{
>> +       xt_unregister_target(&xt_l2info);
>> +}
>> +
>> +module_init(xt_l2info_init);
>> +module_exit(xt_l2info_fin);
>> +
>>
>>
>>
>> James King wrote:
>>> On Wed, Dec 17, 2008 at 12:22 PM, Piotr Duszynski <regis44@gmail.com> wrote:
>>>> I wanted to write a module that would track all the MAC information for
>>>> all established connections. Unfortunately, after the module is loaded
>>>> and all the information is being properly recorded to the conntrack
>>>> computer hangs . I can read that it is related with interrupt timeout,
>>>> but after several hours of trying to fix this I am still in the same
>>>> spot . I would really appreciate any guidance in this matter .
>>>>
>>>> +               l2info = nfct_l2info(ct);
>>>> +               if (!l2info) {
>>>> +                       printk(KERN_INFO "Adding L2INFO extension\n");
>>>> +                       l2info = nf_ct_ext_add(ct, NF_CT_EXT_L2INFO,GFP_ATOMIC);
>>> You shouldn't call nf_ct_ext_add from within your target, as your
>>> private structure needs to be added before the conntrack is confirmed
>>> (preferably at allocation time).  From _nf_ct_ext_add() in
>>> nf_conntrack_extend.c:
>>>
>>>  /* Conntrack must not be confirmed to avoid races on reallocation. */
>>> NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
>>>
>>> Take a look at init_conntrack() in nf_conntrack_core.c to see how
>>> nf_conntrack_acct does it.  lxr.linux.no is your friend :)
>>>
>>> HTH,
>>> James
