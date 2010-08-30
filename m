From: Justin Kamerman <justin@kaleco.net>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 15:30:35 -0300
Message-ID: <4C7BF8CB.9080700@kaleco.net>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTikAwPd81RW7-ajL24wh2W-KwmF073zHLYJDoaaK@mail.gmail.com>
Reply-To: justin@kaleco.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nicola Padovano <nicola.padovano@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Elmar Stellnberger <estellnb@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45038 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab0H3Sai (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:30:38 -0400
Received: by qwh6 with SMTP id 6so5102933qwh.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 11:30:38 -0700 (PDT)
In-Reply-To: <AANLkTikAwPd81RW7-ajL24wh2W-KwmF073zHLYJDoaaK@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Although it probably is technically possible, I think you're better off
filtering with matches and actioning with targets. See the iptables
owner match module for filtering on uid and/or gid.

Regards,
Justin Kamerman

On 10-08-30 02:51 PM, Elmar Stellnberger wrote:
> Would it be possible to extend your module so that it only
> drops packages of a certain user or group?
>
> 2010/8/30 Nicola Padovano <nicola.padovano@gmail.com>:
>   
>> Hi all!
>> I've write the following  (and dummy) module that drops all packet...
>> but...now? after i write the module i can use it?
>> for example: i want digit:
>> iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
>> but i don't know how create this new target...
>> I've modified the netfilter makefile e Kbuild file (in net/netfilter),
>> and then i've do 'make' 'make modules' 'make modules_install' but
>> after i digit iptables i have this message
>>
>> "iptables v1.4.2: Couldn't load target `TAR':/lib/xtables/libipt_TAR.
>> so: cannot open shared object file: No such file or directory"
>>
>> what's my problem?
>>
>>
>> code:
>> #include <linux/module.h>
>> #include <linux/skbuff.h>
>> #include <linux/netfilter_ipv4/ip_tables.h>
>> #include <linux/kernel.h>
>> #include <linux/netfilter.h>
>> #include <linux/netfilter_ipv4.h>
>> #include <linux/netfilter/x_tables.h>
>>
>> static unsigned int xt_tar_target(unsigned int hook,
>>                                                 struct sk_buff **skb,
>>                                                 const struct net_device *in,
>>                                                 const struct net_device *out,
>>                                                 int (*okfn)(struct sk_buff*))
>> {
>>    printk(KERN_INFO "ciaociao");
>>    return NF_DROP;
>> }
>>
>> static struct xt_target xt_tar_reg = {
>>    .name       = "TAR",
>>    .family     = AF_INET,
>>    .proto      = IPPROTO_TCP,
>>    .target     = xt_tar_target,
>>    .me         = THIS_MODULE,
>> };
>>
>> static int __init xt_tar_init(void)
>> {
>>    return xt_register_target(&xt_tar_reg);
>> }
>>
>> static void __exit xt_tar_exit(void)
>> {
>>    xt_unregister_target(&xt_tar_reg);
>> }
>>
>> module_init(xt_tar_init);
>> module_exit(xt_tar_exit);
>>
>> MODULE_DESCRIPTION("np des");
>> MODULE_LICENSE("GPL");
>> MODULE_ALIAS("xt_TAR");
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
